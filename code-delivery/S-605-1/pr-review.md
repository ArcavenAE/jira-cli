## Fresh-eyes PR review — PR #712 (S-605-1)

**VERDICT: APPROVE** · Covered SHA: `570d1263b54eb0f877c9b858cecc1d0993e97d03`

Independent final PR-diff review (a different lens from the 9-round Step-4.5 convergence — not a re-run of it). Reviewed the diff, PR description, and the story spec (`origin/factory-artifacts:stories/S-605-1-issue-component-single-key.md`). **No BLOCKING findings. One LOW nit (non-blocking).**

> Posted to GitHub as a review in **COMMENT** state, not APPROVE — the reviewing identity equals the PR author (`Zious11`), so GitHub rejects a formal `--approve` from the author. The APPROVE verdict above is authoritative.

### Scope
Adds `--component` to `jr issue create` (initial components array) and single-key `jr issue edit` (`add:`/`remove:` prefix grammar, native Jira `update`-verb wire shape with an editmeta-gated read-modify-write fallback). Implements BC-3.4.022/024/025 (new) + amendments to BC-3.4.012/013/017/020/021. +4547/-22 across 7 files (bulk of it the 3631-line test suite).

### Claim-by-claim verification (all confirmed against the diff / spec)

| Claim | Result |
|---|---|
| `handle_edit_bulk_fields` byte-identical to develop | PASS — extracted the fn from `origin/develop` and `HEAD` and compared: 3942/3942 chars, identical. `handle_edit_bulk_labels` also identical (3601/3601). |
| `src/cli/component.rs` untouched | PASS — empty diff. |
| Multi-key + `--component` rejected (S-605-2 scope) | PASS — added to the bulk `unsupported` list and the `--label` 13-flag conflict list; exit 64. |
| Native single-PUT wire shape (AC-001/004/005) | PASS — `edit_issue_combined` omits `update` when `None` and omits `fields` when empty; component-only native edit sends exactly `{"update":{"components":[…]}}`, fallback sends exactly `{"fields":{"components":[…]}}`. Test pins the exact bodies + PUT count = 1. |
| RMW fallback remove-matching (HIGH-1 fix) | PASS — predicate matches `ComponentRef::Id` against `c.id` and `ComponentRef::Name` against `c.name` **directly on the embedded Component** (independent id-OR-name), not via collapsed `ComponentRef` equality. Existing survivors re-emitted by identity (`{"id":…}` when present). |
| Numeric-as-id wiring | PASS — `ComponentRefKind::for_input` mirrors `helpers::resolve_component`'s numeric-bypass predicate (`!empty && all ascii_digit`, confirmed at `helpers.rs:628`); numeric input wires `{"id":…}` on both create and edit. |
| Combined-PUT atomicity (Round-7 MEDIUM-1) | PASS — components land in exactly one of `update`/`fields` (mutually exclusive per invocation via the single editmeta gate); other field changes fold into `fields`; Jira validates all fields up front so a bad field rejects the whole edit. |
| Request-type pre-flight guard (AC-009) | PASS — fires before the JSM dispatch fork, exit 64, `any().expect(0)` catch-all confirms ZERO HTTP; stderr names both flags + suggests `jr issue edit --component`. |
| Resolution GET fires once (AC-010) | PASS — `resolve_create_components` fetches `list_components` once regardless of value count. |
| Gate B 5th field (AC-014) | PASS — `components` joins the flag-overlap set, case-insensitive via lowercased key set. |
| `--label`/`--component` mutual exclusion (AC-015) | PASS — extractor pin updated 12→13 members. |
| Dry-run parity (AC-016/017) | PASS — resolution still fires (read-only) before any output; structured `plannedChanges.components` array in JSON, normalized `add:X` echo in table; zero mutation HTTP. |
| JSON-render invariant (#526) | PASS — no `to_string_pretty` / compact-`json!` printing introduced in the src diff. |

### Test quality
Strong and non-vacuous (spot-checked bodies, not just names). Tests assert exact wire-body JSON, exact PUT counts, `any().expect(0)` for zero-HTTP guards, and identity re-emission (`{"id":"30001"}`) in the RMW fallback. 71 component test functions total. Both sides of the accepted cross-identifier divergence are independently test-pinned (`…rmw_cross_identifier_add_remove_accepted_divergence` / `…native_cross_identifier_add_remove_nets_absent`).

### Known/accepted items — sanity-checked as genuinely benign
- **Numeric-component-as-id BC-wording gap:** code wires numeric `--component` as `{"id":…}` while BC-3.4.022/024 literal text only describes `{"name":…}`. Correct, more-useful behavior consistent with BC-8.1.008's established numeric-bypass precedent; flagged as owed BC-wording clarification at F5/F7. Doc-debt, not a code defect.
- **Contradictory cross-identifier add/remove divergence** (native nets absent, RMW nets present): requires self-contradictory input (same component named two ways with opposite verbs in one command); no unrelated component lost on either path; both outcomes test-pinned. Genuinely accepted divergence.

### Findings
- **LOW (non-blocking):** `edit_issue_combined`'s empty-`fields` guard `!fields.as_object().is_some_and(|m| m.is_empty())` correctly omits an empty object but would insert a non-object `fields` (e.g. `Value::Null`) if a caller ever passed one. All current callers pass a `serde_json::Value` object, so there is no reachable defect — latent robustness nit only. Optional to tighten.

No CRITICAL / HIGH / MEDIUM findings.

### CI
All completed jobs green at review time: Clippy (ubuntu + windows), Format, MSRV (1.85.0), Test (ubuntu), Deny, Spec Guards, gitleaks, dependency-review, Signing Workflow Injection Guard. Test (macOS/windows) + Mutation + Coverage still running. Merge remains gated on human authorization per DEC-128.
