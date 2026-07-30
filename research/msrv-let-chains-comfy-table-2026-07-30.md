---
document_type: research
date: 2026-07-30
topic: >-
  Rust let-chains stabilization version and the last comfy-table 7.x release
  that compiles on Rust 1.85.0 — input to the jr MSRV decision (pin comfy-table
  vs. raise declared rust-version)
status: conclusive
confidence: high
verification_method: >-
  Local empirical compilation against real rustup toolchains 1.85.0 and 1.88.0,
  plus crates.io API, published .crate manifests (Cargo.toml + Cargo.toml.orig),
  and first-party Rust release artifacts.
sources:
  - https://raw.githubusercontent.com/rust-lang/rust/master/RELEASES.md
  - https://blog.rust-lang.org/2025/06/26/Rust-1.88.0/
  - https://github.com/rust-lang/rust/pull/132833
  - https://github.com/rust-lang/rust/issues/53667
  - https://crates.io/api/v1/crates/comfy-table
  - https://crates.io/api/v1/crates/comfy-table/versions
  - https://static.crates.io/crates/comfy-table/comfy-table-7.2.0.crate
  - https://static.crates.io/crates/comfy-table/comfy-table-7.2.1.crate
  - https://static.crates.io/crates/comfy-table/comfy-table-7.2.2.crate
  - https://raw.githubusercontent.com/Nukesor/comfy-table/main/CHANGELOG.md
  - https://raw.githubusercontent.com/Nukesor/comfy-table/main/Cargo.toml
  - https://github.com/Nukesor/comfy-table/blob/main/README.md
---

# MSRV research: let-chains stabilization and comfy-table 1.85 compatibility

## Problem context

`jr` declares `rust-version = "1.85"` in `Cargo.toml`. The CI "MSRV" job was
silently validating `stable` rather than 1.85 due to a misconfigured
`dtolnay/rust-toolchain` step. After that was fixed, the first genuine 1.85.0
check failed:

```
error[E0658]: `let` expressions in this position are unstable
  --> comfy-table-7.2.2/src/utils/arrangement/disabled.rs:21:12
  --> comfy-table-7.2.2/src/utils/formatting/content_format.rs:101:12
error: could not compile `comfy-table` (lib) due to 2 previous errors
```

The dependency is declared `comfy-table = "7"` and resolves to 7.2.2. The
declared MSRV of 1.85 is therefore **false** — the dependency graph does not
build on 1.85.0.

---

## Q1 — Which stable Rust release stabilized let chains?

**Answer: Rust 1.88.0, released 2025-06-26.**
**Confidence: high.** Three independent first-party sources agree.

### Evidence

1. **`RELEASES.md`**, under the 1.88.0 heading:

   > "Stabilize `#![feature(let_chains)]` in the 2024 edition. This feature
   > allows `&&`-chaining `let` statements inside `if` and `while`, allowing
   > intermixture with boolean expressions."

2. **Official release blog post** (`blog.rust-lang.org/2025/06/26/Rust-1.88.0/`)
   confirms both version and date, and gives the gating rationale:

   > "Let chains are only available in the Rust 2024 edition, as this feature
   > depends on the `if let` temporary scope change for more consistent drop
   > order."

3. **Stabilization PR rust-lang/rust#132833**, titled "Stabilize let chains in
   the 2024 edition", merged into the **1.88.0** milestone. It references
   tracking issue #53667 and RFC 2497 — the exact identifiers in the problem
   statement. The PR states:

   > "The feature will only be stabilized for the 2024 edition and future
   > editions. Users of past editions will get an error with a hint to update
   > the edition."

### Nuance that matters for MSRV wording

Stabilization is **edition-gated to Rust 2024 and later**. The precise claim is
"requires Rust >= 1.88 **and** edition 2024", not merely "requires 1.88". A
crate on edition 2021 cannot use let chains even on Rust 1.95. comfy-table is
`edition = "2024"` from 7.2.0 onward, so it satisfies the edition half of the
requirement; only the toolchain half was newly violated.

### Does E0658 map specifically to let chains?

**The error code alone does not; the full diagnostic does.**

`E0658` is the *generic* "use of unstable language or library feature" code. It
is emitted for many different gated features and is **not** let-chains-specific.
Reading only `error[E0658]` would be insufficient to identify the construct.

However, the mapping is certain in this case rather than inferred. Reproducing
the build locally, the compiler's own note reads:

```
= note: see issue #53667 <https://github.com/rust-lang/rust/issues/53667> for more information
```

Issue #53667 is the let-chains tracking issue. Combined with the message text
"`let` expressions in this position are unstable" and the source at both cited
sites being a literal `if let ... && ...` chain, both error sites are
unambiguously the `let_chains` feature gate.

**Practical guidance:** when identifying an unstable construct from CI logs,
key off the `note: see issue NNNNN` line, not the `E0658` code.

---

## Q2 — Last comfy-table 7.x that builds on Rust 1.85.0

**Answer: 7.2.1 (published 2025-09-11).**
**Confidence: high** — established by actually compiling each candidate with
`rustup run 1.85.0 cargo build`, not by reading manifests.

### Empirical build matrix

| Version | Published  | Declares `rust-version` | `cargo build` on 1.85.0 |
|---------|------------|-------------------------|-------------------------|
| 7.2.0   | 2025-08-28 | `1.85`                  | exit 0 (success)        |
| 7.2.1   | 2025-09-11 | `1.85`                  | exit 0 (success)        |
| 7.2.2   | 2026-01-13 | **absent**              | exit 101, `E0658` x2    |

7.2.2 additionally builds clean on **1.88.0** (exit 0), which brackets its real
requirement between 1.85 (fails) and 1.88 (succeeds).

Reproduction used the published `.crate` artifacts from `static.crates.io`
extracted to a scratch directory, built with the locally installed
`1.85.0-aarch64-apple-darwin` (`rustc 1.85.0 (4d91de4e4 2025-02-17)`) and
`1.88.0` toolchains.

### Which release introduced the let-chains usage: 7.2.2

Both offending sites are nested-`if let` -> let-chain rewrites of code that
already existed in 7.2.1. `src/utils/formatting/content_format.rs`:

```rust
// 7.2.1 — compiles on 1.85
if let Some(lines) = row.max_height {
    if cell_lines.len() > lines {

// 7.2.2 — E0658 on 1.85
if let Some(lines) = row.max_height
    && cell_lines.len() > lines
{
```

The same transformation appears at `src/utils/arrangement/disabled.rs:21`:

```rust
// 7.2.1
if let Some(max_width) = constraint::max(table, &column.constraint, visible_columns) {
    if max_width < width {

// 7.2.2
if let Some(max_width) = constraint::max(table, &column.constraint, visible_columns)
    && max_width < width
{
```

These are stylistic refactors, not functional changes — consistent with the
7.2.2 changelog describing only "minor performance improvements" and two
rendering fixes.

### The `rust-version` field was actively removed in 7.2.2

This is worse than "7.2.2 never declared an MSRV". Earlier 7.2.x releases
**did** declare one, and 7.2.2 deleted it in the same release that raised the
real requirement.

From the published `Cargo.toml.orig` (the author's own manifest as uploaded,
before cargo normalization):

- **7.2.1** line 12: `rust-version = "1.85"`, line 13: `edition = "2024"`
- **7.2.2** line 12: `edition = "2024"` — the `rust-version` line is gone

`grep -c rust-version` on the 7.2.2 manifest returns 0, and the current `main`
branch manifest (still version 7.2.2) also has zero matches. So the removal
persists upstream and is not a packaging artifact of one release.

Net effect: the one release that pushed the real floor from 1.85 to 1.88 is
also the release that removed the field cargo would have used to enforce it.
That is precisely why resolution silently pulled an incompatible version — with
no `rust-version` present, cargo had no MSRV constraint to check.

Full `rust-version` history across the 7.x line (from the crates.io versions
API, which surfaces the field per release):

| Version range      | Declared `rust-version` |
|--------------------|-------------------------|
| 7.0.0 – 7.1.4      | `1.64`                  |
| 7.2.0 – 7.2.1      | `1.85`                  |
| 7.2.2              | none                    |

### Changelog silence

The 7.2.2 changelog entry documents only:

- Minor performance improvements
- Fixed edge case with multiple `LowerBoundary` constraints
- Fixed table misformatting without vertical border styling

**No mention of MSRV, edition, `rust-version`, or let chains.**

By contrast, 7.2.0's entry explicitly said:

> "Switch to Rust 2024 edition. This bumps the MSRV to `1.85`."

So the project has documented an MSRV bump before, and simply did not this
time. The omission looks inadvertent rather than policy-driven.

### Stated MSRV policy — it exists, and it permits this

From the project README:

> "Comfy-table is written for the current `stable` Rust version. Older Rust
> versions may work but aren't officially supported."

There is no formal MSRV guarantee and no statement restricting toolchain bumps
to major or minor releases. Under this policy, **raising the required toolchain
in a patch release is within comfy-table's stated contract.** There is no
promise being violated, so there is no upstream bug to report on those grounds
and no basis for expecting a revert.

Corroborating that: a GitHub search across comfy-table issues and PRs for
MSRV/let-chains terms returned **no report of the 7.2.2 break**. The unreleased
7.2.3 changelog section is empty and `main` still carries no `rust-version`.
Assume future 7.2.x releases continue to require 1.88.

### Is there an 8.x line?

**No.** The crates.io versions API shows major lines 0 through 7 only;
`max_version` and `newest_version` are both `7.2.2`. There is no 8.x release,
so the question of whether 8.x declares an MSRV does not arise.

---

## Source disagreements and limits

- **No source-vs-source conflict on the Rust version.** `RELEASES.md`, the
  release blog post, and PR #132833 all independently give 1.88.0 /
  2025-06-26.

- **The real inconsistency is internal to comfy-table 7.2.2:** actual
  requirement 1.88, declared requirement none, changelog silent, immediate
  predecessor declared 1.85. That four-way mismatch is the root cause of the CI
  surprise.

- **One stated inference, not a measurement.** Verified empirically that 1.85.0
  fails and 1.88.0 succeeds for 7.2.2. **1.86 and 1.87 were not tested.** The
  claim that 7.2.2's true floor is exactly 1.88 rests on the reasoning that the
  only two compile errors are `let_chains` gate hits and that gate lifted in
  1.88 — sound, but not directly measured. If "comfy-table 7.2.2 requires
  1.88" is to appear in user-visible text, confirm the 1.87.0 negative first.
  The 7.2.1-builds-on-1.85.0 claim, which is the load-bearing one for the pin
  decision, **is** directly measured.

---

## Decision-relevant implications for `jr`

Stated as consequences of the facts above; the choice is the maintainer's.

1. `comfy-table = "7"` will keep resolving to 7.2.2 and will keep failing on
   1.85.0. The status quo is a false declared MSRV.

2. **To hold `rust-version = "1.85"`:** pin to a 1.85-compatible release
   (`=7.2.1`, or a range such as `>=7.2, <7.2.2`). Because comfy-table declares
   no `rust-version` on 7.2.2+, nothing in the dependency's own metadata will
   stop a future `cargo update` from re-breaking the build — so the pin needs
   an explanatory comment naming this document, and the now-correctly-configured
   MSRV CI job is the only real guard.

3. **To raise the declared MSRV:** the honest floor is **1.88** (subject to the
   1.87 caveat above), not something between 1.85 and 1.88.

4. **Note the hard floor either way:** comfy-table >= 7.2.0 is `edition = "2024"`,
   which itself requires Rust >= 1.85. So 7.2.1 sits exactly on `jr`'s current
   declared MSRV boundary — there is no room to lower `jr`'s MSRV below 1.85
   while staying on the comfy-table 7.2.x line at all.

5. Per project convention, any external version/tracker claim reaching
   user-visible text (CHANGELOG, stderr, docs) should carry the citations in
   this document's `sources` list.
