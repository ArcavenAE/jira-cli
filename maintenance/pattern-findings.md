# Maintenance Sweep 3 — Pattern-Consistency

- **Date:** 2026-08-25
- **Scope:** `src/` (read-only, no code modified, no PRs opened)
- **Config:** `pattern auto_pr=false` — findings are log-for-human only.

## 1. Lint suppressions (`#[allow(...)]`)

`grep -rn "#\[allow(" src/` → 4 hits total (1 real attribute usage location outside doc
comments already excluded below is actually only 2 real attributes; the other 2 hits are
doc-comment *guidance text*, not attributes).

| Location | Attribute | Justified? | Notes |
|---|---|---|---|
| `src/adf.rs:8905` | `#[allow(clippy::too_many_lines)]` | ✅ Yes | On a `#[test]` fn (`test_adf_structural_validity_comprehensive_corpus`); preceded by a 4-line comment explaining it's a deliberate combinatorial corpus test that would lose coverage guarantees if split. Test-only, not lib/bin code. |
| `src/api/refresh_coordinator.rs:56` | `#[allow(dead_code)]` | ✅ Yes | On `reset_for_test`, itself `#[cfg(test)]`-gated; 3-line doc comment explains it's test-only plumbing, "Not called in production." |
| `src/types/jira/editmeta.rs:23` | *(not an attribute)* | N/A | Doc-comment text instructing a future maintainer when it would be OK to add `#[allow(dead_code)]` — no attribute is actually present. |
| `src/types/jira/editmeta.rs:62` | *(not an attribute)* | N/A | Same — guidance text only, no attribute applied. |

**Verdict: no un-justified `#[allow]` found.** Both real attributes are test-scoped and carry
explanatory comments, consistent with "No lint suppression without refactoring." Zero
`#[allow]` exists anywhere in non-test lib/bin code — the policy is currently being followed
without exception.

## 2. JSON render invariant (#526)

`grep -rn "serde_json::to_string_pretty\|to_string(&" src/cli/` — the `to_string(&` half of
the pattern matched only `std::io::Read::read_to_string(&mut buf)` call sites (stdin reads
for `--description-stdin`/`--message-stdin` style flags across `create.rs`, `edit.rs`,
`interactions.rs`, `jsm_create.rs`, `api.rs`) — these are unrelated to JSON serialization
and are false-positive matches of the search pattern, not invariant violations.

Re-ran narrower checks:
- `grep -rn "serde_json::to_string_pretty" src/cli/` → **0 hits**.
- `grep -rn "serde_json::to_string(" src/cli/` → **0 hits**.
- `grep -rn "println!.*json!" src/cli/` → **0 hits** (no raw `json!{}` Display-printing).

The only `serde_json::to_string_pretty` call sites in the whole tree are:
- `src/output.rs:21` — this **is** `render_json` itself (the canonical implementation, not a
  bypass).
- `src/cache.rs` (multiple) — these serialize cache files to disk (`~/.cache/jr/...`), not
  `--output json` command output; out of scope for the #526 invariant, which governs CLI
  stdout, not on-disk cache format.

**Verdict: no JSON render invariant bypass found in `src/cli/`.** All 31 files touching
`render_json`/`print_output` route through the shared helper; no direct
`serde_json::to_string_pretty` or compact `json!{}` Display-printing exists in `src/cli/`.

## 3. `unsafe` usage

`grep -rn "unsafe" src/` → ~90 hits, but almost all are either (a) the substring "unsafe"
inside comments/error-message text (`"...contains unsafe characters..."`,
`"cell-unsafe characters"`, doc-comment prose about `unsafe { set_var }` being unsound under
`#[tokio::main]`), or (b) real `unsafe { std::env::set_var(...) }` / `remove_var(...)` blocks
that are **entirely confined to test code** (`#[cfg(test)]` modules in `cache.rs`,
`config.rs`, `api/auth.rs`, `cli/auth/tests/mod.rs`) working around the Rust 2024
`std::env::set_var`/`remove_var` becoming `unsafe` fns, needed for env-var-based test
isolation seams (`XDG_CACHE_HOME`, `JR_SERVICE_NAME`, etc. — documented in CLAUDE.md's "AI
Agent Notes" seam list).

Zero `unsafe` blocks exist in non-test lib/bin code — grep found no `unsafe` in any
production code path outside a `#[cfg(test)]` module or a `#[test]` fn. This matches
CLAUDE.md's "No unsafe code without explicit justification" policy: the only real usages are
test-scoped, and every call site already sits next to a comment (in `config.rs`/`main.rs`)
explaining *why* it's unsound to lift the pattern into `#[tokio::main]` production code —
i.e., the justification is for *not* using unsafe in prod, which is itself good documentation
discipline.

**Verdict: no un-justified `unsafe` in production code.** Nothing to flag.

## 4. Error handling consistency (`.unwrap()` / `panic!` / `.expect()`)

Raw grep found 1,059 hits, but the overwhelming majority are inside `#[cfg(test)]` modules
(inline unit tests per project convention). Filtered to only hits that appear **before** a
file's first `#[cfg(test)]` marker (i.e., plausibly production code), excluding
`src/cli/auth/tests/mod.rs` (a test-only file despite lacking its own `#[cfg(test)]` marker —
gated by its parent module instead).

Result: **38 hits across 20 files** — every one of them is guarded by an invariant that's
either commented inline or evident from the immediately preceding control flow (an `if
X.is_some()` check, a `match len() { 1 => ... }` arm, a clap `requires`/mutual-exclusion
guard, or a "checked above" comment). None are on a path directly reachable by unvalidated
user input without a preceding guard. Representative sample (full list available on request):

- `src/cli/issue/helpers.rs:135,192,290,359,532,543` — all `.expect("matched name must exist
  in teams/users")` / `"results.len() == 1 checked above"` style, guarded by a preceding
  `partial_match`/length check.
- `src/cli/issue/attachments.rs:2165-2166` — `.expect("clap ensures issue is Some when aids is
  empty")` — guarded by clap arg-group validation.
- `src/cli/sprint.rs:50` — `.expect("clap enforces --sprint when --current is absent")`.
- `src/adf.rs:723,759,1533,1537` — internal ADF-tree invariants ("len checked == 1 above").
- `src/api/auth.rs:851`, `src/api/assets/linked.rs:224,228` — "derived from X so it must
  exist" / "checked above" style.
- `src/main.rs:198` — `.expect("failed to register SIGINT handler for
  JR_TEST_BLOCK_UNTIL_SIGINT seam")` — debug-only test seam, gated `#[cfg(all(debug_assertions,
  unix))]` per CLAUDE.md.

**Four hits lack an explanatory comment**, though each is still guarded by adjacent control
flow rather than being a raw unchecked unwrap on unvalidated input — flagged as a **minor
maintainability drift** (LOW), not a correctness defect:

| Location | Code | Why it's actually safe |
|---|---|---|
| `src/cli/issue/field_resolve.rs:340` | `let fl = field_list.as_ref().unwrap();` | Runs 3 lines after `field_list = Some(fresh);` on the line directly above — infallible by construction, just uncommented. |
| `src/cli/component.rs:394` | `1 => Some(users.into_iter().next().unwrap().account_id)` | Inside a `match users.len() { 1 => ... }` arm — length invariant is the match arm itself, but no comment states it. |
| `src/cli/component.rs:681` | `1 => { ...users.into_iter().next().unwrap()... }` | Same pattern as above (duplicated ~290 lines later — could share a helper). |
| `src/jql.rs:92` | `clauses.into_iter().next().unwrap()` | Inside `if clauses.len() == 1 { ... }` — invariant is the enclosing `if`, uncommented. |
| `src/partial_match.rs:27-28` | `exact_matches.into_iter().next().unwrap()` (×2) | Inside `match exact_matches.len() { 1 => ..., n if n > 1 => ... }` — invariant is the match arm, uncommented. |

None of these are new defects — they follow the codebase's existing convention of
match-arm-guarded/`if`-guarded unwraps, just without the explanatory comment most sibling
call sites carry (`helpers.rs`, `attachments.rs`, `sprint.rs` all comment theirs). Worth a
drive-by comment pass, not urgent.

**Verdict: no unguarded `panic!`/`.unwrap()`/`.expect()` on a user-input-reachable path found.**
The 5 uncommented-but-guarded cases above are the only actionable item, and they're cosmetic.

## 5. Module size vs ADR-0012 (1,000 LOC shard threshold)

`find src -name '*.rs' | xargs wc -l | sort -rn | head -20`:

| LOC | File | Status |
|---|---|---|
| 11,993 | `src/adf.rs` | ✅ Documented ADR-0012 exception |
| 3,472 | `src/cli/issue/attachments.rs` | 🔴 **Undocumented** — over 3.4× threshold, not in "Known Size Deviations" |
| 3,186 | `src/cli/issue/edit.rs` | ✅ Documented (~3,187 LOC pinned — matches) |
| 2,659 | `src/cache.rs` | 🟡 Outside literal ADR-0012 scope (not `src/cli/`); undocumented, largely test-heavy (unsafe env-var blocks start ~line 850) |
| 2,622 | `src/api/client.rs` | 🟡 Outside literal ADR-0012 scope (not `src/cli/`); undocumented |
| 2,012 | `src/cli/issue/list.rs` | 🔴 **Stale documentation** — CLAUDE.md pins "1,256 LOC post-split," actual is 2,012 (+756 LOC, +60%) since that entry was last updated |
| 1,999 | `src/config.rs` | 🟡 Outside literal ADR-0012 scope; undocumented |
| 1,926 | `src/api/auth.rs` | ✅ Documented ADR-0012 exception |
| 1,796 | `src/cli/component.rs` | ✅ Documented (~1,800 LOC pinned — matches) |
| 1,356 | `src/cli/mod.rs` | 🔴 **Undocumented**, in-scope for ADR-0012 (`src/cli/`) |
| 1,277 | `src/cli/issue/workflow.rs` | ✅ Documented (~1,277 LOC pinned — exact match) |
| 1,177 | `src/api/jira/issues.rs` | 🟡 Outside literal ADR-0012 scope (`src/api/`, not `src/cli/`); undocumented |
| 1,113 | `src/cli/issue/helpers.rs` | 🔴 **Undocumented**, in-scope for ADR-0012 (`src/cli/`) |
| 1,018 | `src/cli/auth/tests/mod.rs` | ⚪ Test file (inline integration tests + insta snapshots per architecture doc) — not production shard candidate |
| 957 | `src/api/jira/bulk.rs` | Below threshold, no action |

**Findings requiring attention:**

1. **`src/cli/issue/attachments.rs` (3,472 LOC) is the single largest undocumented gap.**
   It's strictly in ADR-0012's stated scope (`src/cli/`), at over 3× the shard threshold, and
   has no entry in CLAUDE.md's "Known Size Deviations" section at all. This is the most
   significant finding in this sweep — either it needs a documented-exception entry (with
   rationale, mirroring the `component.rs`/`edit.rs` entries) or it's a genuine shard
   candidate that maintenance should schedule.
2. **`src/cli/issue/list.rs`'s documented LOC (1,256) is stale by 756 lines (+60%).** The
   "Known Size Deviations" entry hasn't been updated since a prior split; whatever grew it
   since (component/sort/updated-recent filters per recent commit history: `--component`,
   `--sort`, `--updated-recent` were all added to `list.rs` per the module tree comment) was
   never reconciled against the documented count. Doc-drift, not a code defect — but the
   documented number is now materially misleading for anyone using it to gauge whether
   `list.rs` needs a shard pass.
3. **`src/cli/mod.rs` (1,356 LOC)** and **`src/cli/issue/helpers.rs` (1,113 LOC)** are both
   in-scope (`src/cli/`), over the 1,000-LOC threshold, and absent from "Known Size
   Deviations." Neither is flagged elsewhere as an ADR-0012 exception.
4. `src/cache.rs`, `src/api/client.rs`, `src/config.rs`, `src/api/jira/issues.rs` sit outside
   ADR-0012's literal `src/cli/` wording, so they aren't technically non-compliant with the
   rule as written — flagged only as a heads-up that the rule's rationale (maintainability of
   large single files) applies just as much outside `src/cli/`, and these four are trending
   toward the same shard-candidate territory without any documented decision either way.

## 6. `let`-chains (MSRV 1.85 violation check)

`grep -rn "if let.*&&\|&& let" src/` → **0 hits.**

**Verdict: fully compliant.** No `let`-chain syntax anywhere in the tree — consistent with
the MSRV-1.85 constraint documented in CLAUDE.md ("Temporary — delete this entry ... when
MSRV is raised to ≥1.88").

## Recommended actions

Per `pattern auto_pr=false`, these are log-for-human findings; none are auto-fixed.

| # | Action | Priority | Auto-fixable? |
|---|---|---|---|
| 1 | Add a "Known Size Deviations" entry for `src/cli/issue/attachments.rs` (3,472 LOC) — either document the rationale (mirrors `component.rs`'s CWE-related-complexity framing — attachments.rs owns upload/download/delete/sanitize across platform+JSM dual paths) or schedule a shard pass. | **Medium** | No — needs a maintainer decision on document-vs-shard. |
| 2 | Update `src/cli/issue/list.rs`'s "Known Size Deviations" entry from 1,256 → 2,012 LOC (or re-evaluate whether a further split is now warranted given the growth). | **Medium** | No — needs a one-line CLAUDE.md edit + judgment call on whether growth is now "DOCUMENT-AS-IS-COMPLETE" or warrants action. |
| 3 | Decide whether `src/cli/mod.rs` (1,356 LOC) and `src/cli/issue/helpers.rs` (1,113 LOC) need "Known Size Deviations" entries or a shard pass. | **Low** | No. |
| 4 | Add a one-line justification comment to the 5 uncommented-but-guarded `.unwrap()` call sites (`field_resolve.rs:340`, `component.rs:394`, `component.rs:681`, `jql.rs:92`, `partial_match.rs:27-28`) for consistency with sibling call sites that already comment their invariant. | **Low** (cosmetic) | Yes — trivial comment-only addition, safe to auto-apply if the sweep config allows trivial doc-comment fixes. |
| 5 | (Informational only, no action needed) Consider whether ADR-0012's threshold should explicitly extend beyond `src/cli/` given `cache.rs`/`client.rs`/`config.rs`/`issues.rs` are all approaching or over 1,000–2,600 LOC with no documented policy either way. | **Low** | No — policy question, not a code fix. |

## Summary

| Category | Findings | New un-justified violations? |
|---|---|---|
| 1. Lint suppressions (`#[allow]`) | 0 violations (2 real attrs, both justified + test-scoped) | **No** |
| 2. JSON render invariant (#526) | 0 violations | **No** |
| 3. `unsafe` usage | 0 violations (all real usage is test-scoped, justified by policy) | **No** |
| 4. Error handling (`unwrap`/`panic!`/`expect`) | 5 cosmetic (uncommented but guarded); 0 genuine defects | **No** |
| 5. Module size (ADR-0012) | 4 items needing attention (1 undocumented large file, 1 stale doc count, 2 undocumented mid-size files); 4 informational | N/A — doc-drift, not a code defect |
| 6. `let`-chains (MSRV) | 0 violations | **No** |

**No new un-justified `#[allow]`, `unsafe`, let-chain, or JSON-invariant violation exists.**
The codebase is clean on checks 1, 2, 3, and 6. Check 4 surfaces only cosmetic
(missing-comment) items on already-guarded code, not real defects. The one category with
substantive findings is check 5 (module-size documentation drift): `attachments.rs` growing
undocumented past 3,472 LOC and `list.rs`'s documented count being stale by ~756 lines are
both real gaps in CLAUDE.md's "Known Size Deviations" bookkeeping, not code-quality defects
per se — they're documentation/governance drift that maintenance should reconcile.
