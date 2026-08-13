---
document_type: f3-wave-holdout-scenarios
phase: phase-f3-incremental-stories
epic_id: "BUCKET1-DEFECTS"
producer: story-writer
timestamp: 2026-08-13
status: complete
---

# F3 Wave Holdout Scenarios — Bucket 1 Defect/Enhancement Bundle

Cross-story integration scenarios and regression scenarios for the single
BUCKET1-DEFECTS wave (S-692-1, S-663-1, S-693-1, S-694-1). Because the four
stories are file-disjoint, "cross-story integration" here means confirming the
combined wave diff does not introduce interaction effects (e.g., through
shared modules like `src/main.rs`'s error-exit handler, or shared test
infrastructure) — not that the stories call into each other's new code.

## Cross-Story Scenarios

### H-BUCKET1-001 — Shared error-exit handler unaffected across S-692-1 and S-663-1
Both S-692-1 (dry-run depth-guard exit 64) and S-663-1 (`auth switch
--profile` exit 64) route through the SAME central error-exit handler in
`src/main.rs` for their `--output json` envelope (`{"error","code":64}` on
stderr, stdout empty). Verify BOTH stories' exit-64 JSON-mode tests pass
independently AND that a combined run of the full test suite does not reveal
any handler-level regression introduced by either story's changes (e.g., one
story's fix accidentally widening or narrowing the handler's channel
behavior for the other's error path).
**Pins:** BC-3.4.021 Postconditions-json (channel separation); BC-1.2.047
Postcondition 4 (channel separation). Both cite the SAME `src/main.rs`
error-exit handler and `tests/common/assertions.rs::assert_json_error_envelope`
mechanism — a shared-infrastructure regression risk, even though the two
stories touch disjoint feature code.

### H-BUCKET1-002 — `src/cli/mod.rs` doc-only change (S-694-1) does not perturb CLI parsing used by S-692-1/S-663-1/S-693-1's tests
S-694-1 modifies doc-comment strings only in `src/cli/mod.rs`, on the
`IssueCommand::Attachment` variant and its `Download` subcommand fields —
structurally unrelated to `issue edit`, `auth switch`, or `queue view`
argument definitions. Verify the full test suite (including all `--help`
output snapshot/substring assertions across the whole CLI, not just
attachment tests) remains green after S-694-1 lands, confirming no
accidental clap derive-macro side effect (e.g., a stray syntax error in the
doc comment breaking compilation for the whole binary).
**Pins:** compile-level regression only — no BC directly covers "does adding
a sentence to a doc comment break the build," but `cargo build` + `cargo
clippy -- -D warnings` succeeding is the discriminating proof.

### H-BUCKET1-003 — `jr queue view`'s issue rendering (S-693-1) does not regress `jr issue list`/`jr issue view`'s shared `IssueFields`/`BASE_ISSUE_FIELDS` machinery
S-693-1 adds a non-empty `extra_fields` argument to an existing
`search_issues` call in `src/cli/queue.rs`. `search_issues` itself
(`src/api/jira/issues.rs`) and `IssueFields`'s `#[serde(flatten)] extra`
mechanism are SHARED with `jr issue list`/`jr issue view`/every other
`search_issues` caller. Verify those other callers' existing tests remain
green — their own `extra_fields` arguments (typically `&[]`) are unaffected,
since S-693-1 only changes what `queue.rs`'s specific call site passes.
**Pins:** BC-X.8.009 Trace cites `src/api/jira/issues.rs::search_issues`
(`extra_fields` parameter, pre-existing, non-empty value supplied by this
BC's caller only) — the "only" is the regression-pin claim this scenario
verifies.

## Regression Scenarios (existing behavior unchanged)

### H-BUCKET1-004 — `issue edit --dry-run` for non-description fields unaffected
`jr issue edit FOO-1 --summary "X" --priority "High" --dry-run --output json`
(no `--description`/`--description-stdin`) → `plannedChanges` contains
`summary`/`priority` only, NO `descriptionAdf` key (derived-key absence per
S-692-1's own Postconditions-json item 2). Byte-identical to pre-S-692-1
behavior for every non-description flag.

### H-BUCKET1-005 — `auth login`/`status`/`refresh`/`logout`/`list`/`remove` `--profile` handling unaffected
Full regression pass on the five OTHER `auth` subcommands' `--profile`
handling (composition for Login/Status/Refresh/Logout; direct pass-through
for List/Remove) — S-663-1's guard is `Switch`-only by construction (see
S-663-1 AC-7/AC-8); this scenario is the wave-level confirmation that no
shared dispatch code path was accidentally touched.

### H-BUCKET1-006 — `jr queue view` table output byte-identical for a queue with no custom fields configured
A queue with `fields: null` (or a `fields[]` containing no
`customfield_<digits>`-shaped token) → `jr queue view <name>` table AND JSON
output are byte-identical to pre-S-693-1 output (empty `extra_fields`, same
as before). This is the wave-level confirmation that S-693-1 is genuinely
additive, not merely additive "in the common case."

### H-BUCKET1-007 — `jr issue attachment download`/`upload`/`delete`/`list` behavior byte-identical
Full regression pass on all four attachment subcommands' actual behavior
(batch SHA-1 naming, filter-then-sort-then-truncate, single-file path,
upload/delete flows) — S-694-1 touches help text only; this scenario is the
wave-level confirmation that zero attachment LOGIC changed.

## MUST-PASS Status

All seven holdouts (H-BUCKET1-001..007) are MUST-PASS at the post-wave
integration gate (`vsdd-factory:wave-gate`) before this bundle is considered
converged. None require new test infrastructure beyond what each story's own
AC set already specifies — they are cross-cutting assemblies of existing
per-story test coverage plus full-suite regression runs.
