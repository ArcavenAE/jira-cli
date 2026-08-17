# PR #707 Review — `jr issue list --component` filter (S-606-1)

**Reviewer:** pr-reviewer (fresh-eyes, cognitive-diversity model)
**PR:** https://github.com/Zious11/jira-cli/pull/707
**Base:** develop @ 49a927fd · **Head:** feature/S-606-1-issue-list-component-filter @ 10f030c1
**Scope reviewed:** PR diff, description, tests, demo evidence only (information wall — no `.factory/` artifacts consulted).

## VERDICT: APPROVE

No BLOCKING or HIGH findings. Implementation is correct, well-scoped, thoroughly tested, and matches every claim in the PR description. This is a read-only filter (no Jira mutation). Findings below are LOW/NIT — none blocks merge.

---

## Checklist (8-item)

1. **Diff coherence** — PASS. All changes relate to S-606-1. src touches limited to `list.rs` + `mod.rs`.
2. **Description accuracy** — PASS. BC-2.1.018–022 + BC-2.1.006/007 clause-ordering all present as described; bare/`not:`/`none`/`all:` forms, zero-HTTP pre-flight, and input-order preservation all verified in the diff.
3. **Test coverage** — PASS. 19 component tests observe the actual outbound `POST /search/jql` body via `received_requests()`; meaningful negatives present (input-order-not-sorted, sorted Available/Matches proven by reverse-ordered fixtures, `all:` single-name distinct path, `.expect(0)` zero-HTTP guards, reserved-name collisions for all three forms). Unit test pins clause ordering positionally.
4. **Demo evidence** — PASS (with LOW note). `evidence-report.md` present; 3 real `.gif`/`.webm` recordings (not `.txt`). Only rejection/help paths recorded; happy-path forms are test-derived with a documented, convention-consistent rationale (S-604-*/S-576-* precedent). See LOW-3.
5. **Commit quality** — PASS. Conventional format, story ID present.
6. **Diff size** — Source diff modest (~2 small src edits + tests); binary demo assets inflate the raw count. Reasonable.
7. **Missing changes** — None. All six contracts implemented + tested.
8. **Dependency status** — S-604-1 (`resolve_component` resolver) merged; this PR consumes it. OK.

---

## Verified contract conformance

- **BC-2.1.018** bare OR → `component in (id1, id2)`, single clause, input order preserved (`bare_ids` iterates `values` in order). Pinned by `test_..._or_preserves_input_order_not_sorted` (inverts input vs id-ascending).
- **BC-2.1.019** `not:` → `(component not in (...) OR component is EMPTY)`, parenthesized, multiple `not:` grouped. JQL semantics correct — `not in` alone drops NULL-component issues, so `OR is EMPTY` is genuinely required.
- **BC-2.1.020** `none` → `component is EMPTY`, zero resolver HTTP (early return before `list_components`), case-insensitive, project-scope still enforced.
- **BC-2.1.021** `all:` → `component = id1 AND component = id2` (repeated equality, not IN) — correct "has every listed component" semantics.
- **BC-2.1.022 / VP-COMPONENT-013** — resolution runs before `build_filter_clauses`/search POST; unresolvable/ambiguous → exit 64 with zero `POST /search/jql` (asserted via `.expect(0)`).
- **BC-2.1.006/007** clause-ordering — `parts.extend(component_clauses)` after `asset_clause`, before date clauses; positional `assert_eq!` unit test + AC-016 integration test.
- Zero-HTTP pre-flight — `validate_component_preflight` is HTTP-free, runs before `project_exists`; `project_key` resolution moved up with old duplicate binding removed (no double-bind).

**Injection surface (positive):** component names never reach the JQL string — always resolved to numeric ids first; only ids interpolated. No name-based JQL injection.

**Scope discipline:** src changes are exactly `list.rs` + `mod.rs`. No `component.rs`/`edit.rs`/`create.rs`. Matches ADR file-disjoint claim.

**Quality gates:** No `#[allow]`/lint suppression, no `unsafe`, no let-chains, exit 64 for user errors, actionable messages naming `--project` with alphabetically-sorted candidate lists.

---

## Findings

| Severity | File | Finding | Suggestion |
|----------|------|---------|------------|
| LOW | src/cli/mod.rs | `--component` + `--jql` interaction untested/unspecified (no `conflicts_with`, no test). Same open question as sibling filters; follows established pattern so risk low. | Add `conflicts_with = "jql"` or one test pinning intended behavior. |
| LOW | src/cli/issue/list.rs (`resolve_component_clauses`/`validate_component_preflight`) | Reserved-prefix case-sensitivity asymmetric: `none` case-insensitive, but `all:`/`not:` case-sensitive (`ALL:`/`NOT:` fall through to literal-name lookup). Internally consistent but could surprise; help text doesn't state it. | Note case-sensitivity in the arg help doc-comment. |
| LOW | docs/demo-evidence/S-606-1 | Happy-path forms (bare OR, `not:`, `all:`) not visually demoed — only rejection/help paths recorded. Documented rationale + strong test coverage; not BLOCKING because demos are real gif/webm, present, and behavior is test-proven. | Optional: add mock-backed VHS recordings for the three success forms, or accept per repo convention. |
| NIT | src/cli/issue/list.rs (`resolve_component_clauses`) | `project_key.expect(...)` is a panic path; safe under current invariant but a future reorder would panic vs error. | Return `JrError::Internal` like the sibling "resolved name not found" case. |
| NIT | src/cli/issue/list.rs (`resolve_one_component_id`) | Degenerate `all:` / trailing-comma yields ugly `Component '' not found` message. Harmless (exit 64, zero search). | Optional: reject empty split segment with a clearer message. |
| INFO | src/cli/issue/list.rs (`resolve_one_component_id`) | `MatchResult::ExactMultiple` picks first-by-list id for duplicate-named components — inherited S-604-1 resolver semantics, out of scope. | No action. |

---

## Posting note

Per the launching agent's explicit instruction — "Do NOT approve or merge via gh (the same-account classifier blocks self-approval anyway, and merge authority is the human's)" — the APPROVE verdict is returned as text and recorded in this file rather than self-posted via `gh pr review`. The same-account classifier would reject a self-approval regardless. Merge authority remains the human's.
