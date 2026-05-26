---
document_type: perplexity-verification
issue: 327
date: 2026-05-26
producer: orchestrator-direct (perplexity_search MCP)
complements: .factory/research/rand-0.10-migration-assessment.md
verdict: PERPLEXITY-CONFIRMS-PRIOR-ASSESSMENT
---

# rand 0.9 → 0.10 — Perplexity Cross-Verification

## 0. Tool availability

The first research-agent invocation (writing `rand-0.10-migration-assessment.md`)
reported "MCP servers were not exposed" and fell back to WebFetch/WebSearch.
A second dispatch to research-agent for an explicit Perplexity pass returned the
same finding — the agent's tool surface did not include `mcp__perplexity__*`
and it correctly refused to silently fall back to WebFetch.

The orchestrator (this session, top-level Claude Code) DOES have
`mcp__perplexity__search` in its deferred-tool surface. The verification was
performed via four parallel `perplexity_search` calls on the high-stakes claims.

Tool used: `mcp__perplexity__search` (Sonar Pro model behind it).

## 1. `OsRng → SysRng` is a hard rename, no deprecation alias

**Prior verdict (from migration assessment §1):** Hard rename, no alias.

**Perplexity verdict: CONFIRMED.**

Perplexity confirms:
- The `rand::rngs` module in 0.10 exposes `SysRng` only — no `OsRng` type, no
  re-export, no `#[deprecated]` shim. Cite: `docs.rs/rand/latest/rand/rngs/`.
- The official "Updating to 0.10" Rand Book page says: "`rand_core::OsRng` has
  been replaced with `getrandom::SysRng` (also available as
  `rand::rngs::SysRng`)" — framed as "replaced," not "aliased." Cite:
  `rust-random.github.io/book/update-0.10.html`.
- No community report (Reddit / Discord / blog) was surfaced contradicting
  this — i.e. no one is reporting that the old name still happens to work.

## 2. `TryRngCore → TryRng` is a hard rename, no deprecation alias

**Prior verdict (from migration assessment §1):** Hard rename, no alias.

**Perplexity verdict: CONFIRMED.**

The 0.10 update page enumerates trait renames in the same "replaced with" voice
without any compatibility shim language. Public API of 0.10 only documents
`Rng` and `TryRng` (and `RngExt`); the old names are not visible as deprecated
exports. Cite: `rust-random.github.io/book/update-0.10.html`.

## 3. `try_fill_bytes` signature is unchanged between 0.9.4 and 0.10.1

**Prior verdict (from migration assessment §1):** Unchanged. Same signature.

**Perplexity verdict: CONFIRMED.**

The 0.10 migration doc calls out only ONE trait-method change explicitly:
`TryRngCore::read_adapter` was replaced with `RngReader`. No similar note
exists for `try_fill_bytes`. The trait was renamed in place; the method
survived verbatim. Cite: `rust-random.github.io/book/update-0.10.html`.

## 4. Community-surfaced gotchas beyond the headline CHANGELOG

**Prior verdict (from migration assessment §7):** None beyond changelog
headlines; community migration reports describe the same five edits as the
official guide.

**Perplexity verdict: CONFIRMED.**

Perplexity explicitly notes: "0.10 is very new (released Feb 2026), so blog
posts / Reddit / Discord war stories are scarce." The official 0.10 update
page states: "There are no known value-breaking changes to rand in v0.10."

Specific sub-claims checked:

- **`OsError → SysError` error handling:** No notable community wave of
  problems. Compile-time fixes, trivial. ✅
- **`Fill` trait element-vs-slice change (#1652):** Compile-time break for
  custom `Fill` implementors only. No silent behavior changes reported. We do
  not implement `Fill` (jr uses `try_fill_bytes` on the RNG directly). ✅
- **`getrandom` cascade effects:** No runtime-regression reports specifically
  attributable to `getrandom 0.4` via rand 0.10. Main `rand`+`getrandom`
  cluster of advisories is RUSTSEC-2026-0097 itself (separate issue, see §6).
  ✅
- **`chacha20` replacing `rand_chacha` for `StdRng`:** Maintainers explicitly
  promise "these maintain reproducibility of output." No community report of
  seed-for-seed regression. ✅ (Moot for us — we don't use `StdRng`.)
- **Lockfile resolution with rand 0.9 + 0.10 coexistence:** Standard "two
  major versions" situation. Cargo handles coexistence; cannot pass RNG
  types across the major-version boundary. No special lockfile bug pattern
  beyond the obvious. ✅ (Matches the migration assessment's `deny.toml`
  skip-list plan.)

Cite: `rust-random.github.io/book/update-0.10.html`,
`github.com/rust-random/rand/issues/1643` (the v0.10 tracker — mostly design
discussion, not breakage reports).

## 5. `rand 0.10.2` imminence / yanks / post-release critical issues

**Prior verdict (from migration assessment §8):** No 0.10.2 imminent. No
yanks. No critical post-release issues.

**Perplexity verdict: CONFIRMED.**

- Latest stable on crates.io is `0.10.1`. No `0.10.2` listed.
- Neither `0.10.0` nor `0.10.1` is yanked.
- No publicly visible GitHub milestone, issue, or PR referencing a planned
  0.10.2 in `rust-random/rand`.
- No newer RustSec advisories targeting rand 0.10.x beyond RUSTSEC-2026-0097.
- Maintainers' "no known value-breaking changes" statement is still standing.

Cite: `crates.io/crates/rand`, `rust-random.github.io/book/update-0.10.html`,
`rustsec.org/advisories/RUSTSEC-2026-0097.html`.

## 6. GHSA-cq8v-f236-94qc / RUSTSEC-2026-0097 applicability

**Prior verdict (from migration assessment §3):** Bug does NOT affect our
code path. Requires `log` feature + custom logger + `rand::rng()` /
`ThreadRng` + reseed during the borrow.

**Perplexity verdict: CONFIRMED.**

Exact required conditions per Perplexity (cross-checked against
`rustsec.org/advisories/RUSTSEC-2026-0097.html` and the GHSA page):

- `log` feature enabled in `rand` ✗ (we don't enable it)
- `thread_rng` feature enabled (default in 0.9/0.10)
- **Custom `log` logger installed** ✗ (we don't install one)
- Logger calls `rand::rng()` / `thread_rng()` and uses `ThreadRng` methods ✗
- `ThreadRng` hits a reseed attempt inside that logger call ✗

**Critical sub-question — "Is there ANY exploitation path that does NOT involve
ThreadRng?":** Perplexity searched directly and reports: "I found no
exploitation path in the advisory that does not involve `ThreadRng`. The
advisory is explicitly scoped to `rand::rng()` / `rand::thread_rng()` and says
the unsafe cast is in `TryRng` methods for `ThreadRng`; it does NOT mention
`OsRng`/`SysRng` as affected."

`generate_state` reads from `SysRng` only (one-shot, no reseed state, no
logger involvement). **Zero exposure to this advisory.**

Cite: `rustsec.org/advisories/RUSTSEC-2026-0097.html`,
`github.com/advisories/GHSA-cq8v-f236-94qc`,
`docs.rs/rand/latest/rand/rngs/struct.SysRng.html`.

## 7. MSRV / Edition 2024 friction

**Prior verdict (from migration assessment §5):** No friction; project at
1.85 / Edition 2024 already.

**Perplexity verdict: CONFIRMED (incidentally).**

Perplexity §3 (response on getrandom cascade) notes the migration "raises MSRV
requirement (from `rand` needing newer `getrandom` and thus newer std /
platform support)." Our project meets the 1.85 floor; no further friction.

## 8. `cargo deny multiple-versions` with rand 0.9 + 0.10 dual-presence

**Prior verdict (from migration assessment §6):** Dual-presence requires
`[[bans.skip]]` entries; possibly also `rand_core 0.9` + `rand_core 0.10`.

**Perplexity verdict: CONFIRMED.**

Perplexity §5 (response on lockfile resolution) confirms `rand_core 0.9` vs
`rand_core 0.10` are "incompatible at the trait level" and will appear as
separate versions in the resolved graph. No community report of additional
problems beyond the documented "two major versions" pattern. The migration
assessment's `cargo tree -d -i rand_core` step at F4 start will confirm
whether the rand_core skip pair is needed (likely yes).

## 9. Delta vs prior assessment

| Claim | Prior verdict | Perplexity verdict | Divergence? |
|---|---|---|---|
| OsRng → SysRng hard rename | Confirmed via docs.rs | CONFIRMED | None |
| TryRngCore → TryRng hard rename | Confirmed via docs.rs | CONFIRMED | None |
| try_fill_bytes signature unchanged | Confirmed via docs.rs | CONFIRMED | None |
| No community gotchas beyond changelog | Inferred from absence of search hits | CONFIRMED (Perplexity also finds none) | None |
| 0.10.2 not imminent | Confirmed via GitHub releases | CONFIRMED | None |
| No yanks of 0.10.x | Confirmed via crates.io | CONFIRMED | None |
| GHSA requires ThreadRng + log + custom logger | Documented in GHSA | CONFIRMED + sub-question "OsRng-only path?" answered "no such path" | None |
| MSRV 1.85 sufficient | Confirmed | CONFIRMED | None |
| deny.toml dual-presence well-understood | Confirmed | CONFIRMED | None |

**Zero divergences. No claim from the prior assessment was contradicted or
materially amended by Perplexity.**

## Final verdict

**`PERPLEXITY-CONFIRMS-PRIOR-ASSESSMENT`**

The F1 / F2 / F3-impending migration plan is supported by two independent
external-research passes (docs/CHANGELOG-direct + Perplexity community
aggregation). Proceed to F3 with confidence.

Caveat retained from the prior assessment: 0.10 is recent (Feb 2026); if a
post-release defect surfaces between now and F7 PR merge, re-run this
verification. The cooldown policy (PR #412) is independent supply-chain
defense and will hold whatever this verification does not.
