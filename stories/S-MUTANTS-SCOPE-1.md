---
document_type: story
level: ops
story_id: "S-MUTANTS-SCOPE-1"
epic_id: null
# epic_id: null — standalone CI-infrastructure + targeted refactor story, no named epic.
title: "Close the queue.rs/main.rs mutation-scope false-green: add both files to examine_globs, extract run_until_shutdown, and land the ctrl_c/SIGINT test pair (VP-MUTANTS-SCOPE-1-001/002)"
wave: feature-followup
status: done
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: small
severity: MEDIUM
trivial_scope: true
points: 5
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1.5
target_module: ci-infrastructure
subsystems: ["SS-01", "SS-08"]
# SS-01 owns src/main.rs (dispatch/runtime entry point) per ARCH-INDEX Subsystem Registry —
# the run_until_shutdown extraction and both new tests for the ctrl_c fork live here.
# SS-08 owns src/cli/queue.rs (JSM queue commands) per ARCH-INDEX Subsystem Registry —
# it becomes a mutation-testing *target* only (no code edit) but is in this story's
# examine_globs scope addition, so it is listed for completeness.
depends_on: []
blocks: []
behavioral_contracts: ["BC-X.3.006"]
bcs: ["BC-X.3.006"]
verification_properties: ["VP-MUTANTS-SCOPE-1-001", "VP-MUTANTS-SCOPE-1-002"]
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/cross-cutting.md#BC-X.3.006; docs/specs/cargo-mutants-policy.md §Scope"
producer: story-writer
timestamp: "2026-08-14T00:00:00"
phase: 3
cycle: null
# cycle: null — standalone F3 story, not part of a named multi-story bundle.
inputs:
  - ".factory/phase-f1-delta-analysis/S-MUTANTS-SCOPE-1-delta-analysis.md"
  - ".factory/phase-f2-spec-evolution/S-MUTANTS-SCOPE-1-spec-delta.md"
  - ".factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md"
  - ".factory/specs/prd/cross-cutting.md"
input-hash: "26d9710"
traces_to: ".factory/specs/prd/cross-cutting.md#BC-X.3.006"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 14
assumption_validations: []
risk_mitigations:
  - "F1 §5/§6 flagged a MEDIUM risk that main.rs's first scoped mutation run dips below the
     90% kill-rate floor even after VP-001/VP-002 land, because init_tracing's level selection
     and the InvalidSubcommand intercept are additional branch-dense regions in the same file
     that this story does not add new tests for (existing tests/verbose_bodies.rs,
     tests/observability.rs, tests/cli_smoke.rs are believed — not exhaustively verified per
     F1 — to already cover them indirectly). This story closes the highest-confidence gap
     (the zero-coverage ctrl_c fork) per the F1 §7 AC-006 human decision below; any residual
     survivors elsewhere in main.rs are explicitly deferred to F6 targeted hardening, not
     silently absorbed into this story's scope."
created: "2026-08-14"
version: "1.0"
last_updated: "2026-08-14"
breaking_change: false
retroactive: false
origin: >
  Drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN, first recorded in STORY-INDEX.md's
  BUCKET1-DEFECTS-COMPLETE entry (2026-08-14): F6 targeted hardening on the bucket1-defects
  cycle observed that PR #696 (src/main.rs) and PR #698/#700 (src/cli/queue.rs) all merged
  through the `mutants` CI gate via its legitimate-but-silent "0 mutants" path, because
  neither file was in `.cargo/mutants.toml::examine_globs`. Promoted to a standalone Feature
  Mode cycle (S-MUTANTS-SCOPE-1) this session. F1 delta analysis:
  .factory/phase-f1-delta-analysis/S-MUTANTS-SCOPE-1-delta-analysis.md. F2 amended
  BC-X.3.006 (Ctrl+C/SIGINT contract) from a thin semport stub to a fully-specified BC with
  two inline Verification Properties, closing the F1 §6 highest-attention risk item (the
  main.rs ctrl_c fork's zero test coverage) via the "write a new signal-based test" option
  (F1 AC-seed #6, option (b) — human-approved at the F1 gate, not silently defaulted).
changelog:
  - "1.0 (2026-08-14): Initial F3 story. Two-file examine_globs addition (queue.rs, main.rs;
     16→18) + policy-doc citation/count sync + behavior-preserving run_until_shutdown
     extraction + VP-MUTANTS-SCOPE-1-001 (#[cfg(unix)] subprocess SIGINT test) +
     VP-MUTANTS-SCOPE-1-002 (portable tokio::test arm-selection unit test). 13 ACs, 5 pts."
  - "1.0 (2026-08-14, surgical amendment): Folded in pre-F4 consistency audit finding M-1
     (human-approved same day) — docs/specs/cargo-mutants-policy.md §Scope documented only
     11 of 16 pre-existing examine_globs entries; 5 undocumented entries (interactions.rs,
     cli/issue/attachments.rs, api/jira/attachments.rs, api/jsm/attachments.rs,
     api/jsm/servicedesks.rs) are now backfilled in the same Task 2 edit as this story's own
     2 new bullets. Added AC-014. Adjusted AC-002 scope note for clarity (no contradiction).
     acceptance_criteria_count 13→14. No new BC; traces to drift item
     MUTANTS-SCOPE-GAP-QUEUE-MAIN. Also fixed L-1 cosmetic nit: Task 4's illustrative
     run() call-site sketch referenced a nonexistent tokio::signal::ctrl_c_ignoring_err()
     helper; replaced with real tokio::signal::ctrl_c() and an explicit pseudocode label."
  - "1.0 (2026-08-14, surgical amendment): Closed pass-4 adversarial finding M-1 (MEDIUM,
     verification-accounting) — clarified that the story's OWN newly-added seam-selection
     scaffolding in run() (test_seam_active condition, work/shutdown boxing fork, ctrl_c()
     adapter) is IN-SCOPE for --in-diff mutation testing, not covered by AC-013's F6
     deferral (which applies only to pre-existing branch-dense main.rs regions). Recorded the
     authoritative empirical result on final branch HEAD 37ac5e41: caught=3, missed=0,
     unviable=4, timeout=0 (100% kill rate over viable mutants, 0 timeout survivors,
     including the seam-selection condition mutant itself). Updated the Regression Risk table
     (new row) and tightened AC-005 and AC-013's wording accordingly. No AC count change
     (still 14); no new BC."
  - "1.0 (2026-08-14, surgical amendment): Closed pass-5 adversarial finding (LOW,
     verification-accounting precision). The Regression Risk table row and AC-013's note both
     listed the production `ctrl_c()` adapter (`~src/main.rs:515-522`) alongside the two
     genuinely mutant-caught lines under a single 'RESOLVED (empirically verified)' label —
     but none of the caught=3 mutants touches that line, and no viable mutant was generated on
     it at all (VP-MUTANTS-SCOPE-1-001 always exercises the `test_seam_active` seam, not the
     real adapter call), so 'RESOLVED/empirically verified' was vacuously true there, not
     affirmative coverage. Reworded both locations to distinguish the affirmatively-covered
     seam-selection condition and seam/`run` bodies from the acknowledged, documented
     no-mutant residual on the `ctrl_c()` adapter line, cross-referencing BC-X.3.006's existing
     race-condition/residual note. No wording change to the overall 'no surviving-mutant risk
     / mergeable' conclusion. No AC count change (still 14); no new BC."
lineage:
  - S-346                      # cargo-mutants CI job + whitelist policy (PR #373, 2026-05-16)
  - S-TESTTOOL-1                # examine_globs expansion: issues.rs + cache.rs (PR #533, 2026-06-18)
  - S-MUTATION-CI-TIMEOUT-1     # --timeout 240, false-green guards (PR #567, 2026-06-28)
  - S-MUTANTS-EXAMINE-GLOBS-1   # examine_globs expansion: edit.rs + jsm_create.rs (DEC-149)
  - S-MUTANTS-SCOPE-GUARDS-1    # Guard 2/Guard 3 self-verifying machinery this story relies on
  - S-693-1                     # PR #698 — merged through the false-green this story closes
  - S-663-1                     # PR #696 — merged through the false-green this story closes
drift_items:
  - MUTANTS-SCOPE-GAP-QUEUE-MAIN
files_modified:
  - .cargo/mutants.toml                 # add "src/cli/queue.rs" + "src/main.rs" to examine_globs (16→18), each with an inline explanatory comment
  - docs/specs/cargo-mutants-policy.md  # §Scope: two new bullets citing real functions (AC-002) PLUS five backfilled bullets for pre-existing undocumented examine_globs entries (AC-014, folded in per pre-F4 consistency audit finding M-1, human-approved 2026-08-14) — 11 pre-existing + 5 backfill + 2 new = 18 total bullets; "Current examine_globs count" line 16→18
  - src/main.rs                         # behavior-preserving extraction of the tokio::select! ctrl_c fork into run_until_shutdown(work, shutdown); inline #[cfg(test)] mod tests for VP-MUTANTS-SCOPE-1-002
  - tests/interrupt_signal.rs           # NEW — #[cfg(unix)] subprocess SIGINT test for VP-MUTANTS-SCOPE-1-001 (name chosen after checking tests/cli_smoke.rs conventions; this test needs raw std::process::Command + libc::kill, a different shape from cli_smoke.rs's assert_cmd-based tests, so it is a new file rather than an addition to cli_smoke.rs)
  - Cargo.toml                          # add explicit "libc" entry under [dev-dependencies] (already a transitive dependency per Cargo.lock — libc 0.2.183 — but Rust requires an explicit Cargo.toml edge to `use` it from test code; no new crate enters the dependency graph)
---

# S-MUTANTS-SCOPE-1 — Close the queue.rs/main.rs Mutation-Scope False-Green

**Status:** DRAFT — F3 complete (2026-08-14); awaiting F4 dispatch.

**Origin:** Drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN`. Three merged PRs (#696, #698, #700)
touched `src/main.rs` and/or `src/cli/queue.rs` while the `mutants` CI job silently reported
"0 mutants" for both files, because neither was in `.cargo/mutants.toml::examine_globs`. The
`mutants` gate mechanism itself is proven correct elsewhere (`edit.rs` ran 4/4 on PR #697) —
this is a scope-coverage gap, not a defect in the gate's decision logic.

**F1 delta analysis:** `.factory/phase-f1-delta-analysis/S-MUTANTS-SCOPE-1-delta-analysis.md`
**F2 spec delta:** `.factory/phase-f2-spec-evolution/S-MUTANTS-SCOPE-1-spec-delta.md`
**Research:** `.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md`
**Governing BC:** `BC-X.3.006` (`.factory/specs/prd/cross-cutting.md` §X.3, AMENDED 2026-08-14)

---

## Governance Note

**Two governance tracks in one story, deliberately not split further (F1 §7: "single small
story — no epic, no sub-story decomposition needed").**

1. **`examine_globs` scope addition** — policy-doc-only governance, same pattern as
   `S-MUTANTS-EXAMINE-GLOBS-1` and `S-TESTTOOL-1`. No BC governs `examine_globs` membership
   (F1 §3 confirmed no direct hit beyond an unrelated documented-gap precedent in
   `bc-5-boards-sprints.md`); `docs/specs/cargo-mutants-policy.md §Scope` is the sole
   governing artifact for this half. ACs for this half trace to the drift item
   `MUTANTS-SCOPE-GAP-QUEUE-MAIN`, not to a BC clause.
2. **`run_until_shutdown` extraction + VP-MUTANTS-SCOPE-1-001/002** — governed by `BC-X.3.006`,
   amended in F2 specifically to anchor these two Verification Properties. ACs for this half
   trace to `BC-X.3.006` Behavior/Edge-Case clauses and to VP-001/VP-002 directly.

**Spec-First Gate (S-7.01) note:** `behavioral_contracts: ["BC-X.3.006"]` is non-empty and
matches the canonical `BC-\d+\.\d{2}\.\d{3}` pattern, so the gate's mechanical precondition
for `status: ready` is satisfied. `status: draft` is nonetheless set deliberately per this
dispatch's explicit instruction — promotion to `ready` is a separate, later decision (e.g.
after F5 scoped adversarial review), not implied by BC presence alone.

---

## Narrative

As a contributor to the `jr` CLI,
I want `src/cli/queue.rs` and `src/main.rs` added to `.cargo/mutants.toml::examine_globs`,
the `docs/specs/cargo-mutants-policy.md` §Scope citations corrected to match, and the
previously-zero-coverage `tokio::select!` Ctrl+C/SIGINT fork in `src/main.rs` given a
behavior-preserving `run_until_shutdown` extraction plus a matched pair of tests (one
portable, one out-of-process signal-based),
so that PRs touching either file face real mutation testing instead of the silent
"0 mutants" false-green that let PRs #696/#698/#700 merge unchecked, and so that the
highest-risk region of `main.rs` (the interrupt path) has real regression coverage instead
of zero.

---

## Traceability

| Source | Link |
|--------|------|
| Drift item origin | `MUTANTS-SCOPE-GAP-QUEUE-MAIN` (STORY-INDEX.md BUCKET1-DEFECTS-COMPLETE entry, 2026-08-14) |
| F1 delta analysis | `.factory/phase-f1-delta-analysis/S-MUTANTS-SCOPE-1-delta-analysis.md` |
| F2 spec delta | `.factory/phase-f2-spec-evolution/S-MUTANTS-SCOPE-1-spec-delta.md` |
| Research (ctrl_c test design) | `.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md` |
| Governing BC | `BC-X.3.006` — `.factory/specs/prd/cross-cutting.md` §X.3 |
| Governing policy doc (examine_globs half) | `docs/specs/cargo-mutants-policy.md §Scope` |
| Root cause examples | PR #696 (`c9218389`), PR #698 (`c34f4db9`), PR #700 (`89164b8d`) |
| Preceding scope story (template for this half) | `S-MUTANTS-EXAMINE-GLOBS-1` (edit.rs + jsm_create.rs, DEC-149) |
| Preceding self-verifying guards | `S-MUTANTS-SCOPE-GUARDS-1` (Guard 2 citation check, Guard 3 glob-existence test) |

---

## Behavioral Contracts

| BC | Clause | Summary |
|----|--------|---------|
| BC-X.3.006 | Behavior item 1 | `run()`'s `tokio::select!` races `main_task` vs. `tokio::signal::ctrl_c()`; `main_task` completing first returns its `Result` unaffected by this story |
| BC-X.3.006 | Behavior item 2 | Interrupt branch does exactly two things in order: `eprintln!("\nInterrupted")` (byte-exact stderr contribution `"\nInterrupted\n"`), then `std::process::exit(130)` |
| BC-X.3.006 | Edge Case EC-1 | SIGINT arrives before `select!` first polls (registration race) → falls through to OS default disposition, NOT this BC's graceful path — the reason VP-MUTANTS-SCOPE-1-001 requires a deterministic readiness handshake, not a fixed sleep |
| BC-X.3.006 | Edge Case EC-2 | SIGINT after `main_task` already won → unreachable (documented, not exercised by a new test) |
| BC-X.3.006 | Edge Case EC-3 | `--output json` invocations still get plain-text `"\nInterrupted\n"`, never a JSON error envelope — pre-existing asymmetry with BC-7.3.010, unaffected by this story |
| BC-X.3.006 | Verification Properties | VP-MUTANTS-SCOPE-1-001 (out-of-process SIGINT test), VP-MUTANTS-SCOPE-1-002 (portable arm-selection test), and an explicit rejection of `#[mutants::skip]` for this block |

The `examine_globs`/policy-doc half of this story has no governing BC (see Governance Note
above); its ACs trace to the drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN` instead.

---

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~5,500 |
| `.cargo/mutants.toml` (full file) | ~350 |
| `docs/specs/cargo-mutants-policy.md` (§Scope only) | ~1,200 |
| `src/main.rs` (full file, 422 LOC) | ~4,500 |
| BC-X.3.006 full body (`cross-cutting.md`) | ~2,000 |
| Research doc (`.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md`) | ~5,500 |
| New `tests/interrupt_signal.rs` (to be written, ~80 LOC) | ~900 |
| `Cargo.toml` ([dev-dependencies] section only) | ~300 |
| **Total** | **~20,250** |

Well within 20–30% of a typical implementer agent's context window. No splitting required.

---

## Tasks

1. **`.cargo/mutants.toml`**: append `"src/cli/queue.rs"` and `"src/main.rs"` to
   `examine_globs` (16 → 18 total). Add an inline `#` comment above each, matching the file's
   existing convention (see the `edit.rs`/`jsm_create.rs`/`interactions.rs` comment blocks).
   Recommended comment content:
   - `queue.rs`: cite `collapse_and_truncate`'s F6-hardened truncation boundary (PR #700) and
     `resolve_queue_by_name`'s partial-match resolution as the HIGH-value surfaces.
   - `main.rs`: cite the previously-zero-coverage `run_until_shutdown` ctrl_c/SIGINT fork
     (this story closes that gap) and the `InvalidSubcommand` intercept as the HIGH-value
     surfaces; note the file is scoped whole-file (cargo-mutants `examine_globs` has no
     sub-file targeting — F1 §5 confirmed this).
2. **`docs/specs/cargo-mutants-policy.md` §Scope**: add two new bullets in the existing
   format, citing real currently-defined functions:
   - `src/cli/queue.rs` — `handle`, `handle_list`, `handle_view`, `resolve_queue_by_name`,
     `extra_fields_allow_list`, `is_customfield_token`, `reorder_by_queue_position`,
     `collapse_and_truncate` (added S-MUTANTS-SCOPE-1)
   - `src/main.rs` — `init_tracing`, `run`, `run_until_shutdown` (added S-MUTANTS-SCOPE-1)
   Correct the "Current `examine_globs` count: 16 entries" line to 18 in the same edit.
   `scripts/check-cargo-mutants-policy-citations.sh` (Guard 2) is fully data-driven — no
   script change required, but run `--self-test` plus a real-mode pass before merging to
   confirm the citation-grep pattern resolves `async fn run(cli: Cli) -> anyhow::Result<()>`,
   `fn init_tracing(cli: &Cli)`, and the new `run_until_shutdown` free function correctly
   (F1 §4 flagged this as worth a dry-run verification, not a known failure).

   **2b. Backfill 5 pre-existing undocumented entries in the SAME edit (AC-014, M-1):**
   the pre-F4 consistency audit found `.cargo/mutants.toml::examine_globs` currently has 16
   entries but §Scope documents only 11 of them — 5 entries added by earlier stories
   (S-576-1, S-576-5, S-577-1, per their inline `.cargo/mutants.toml` comments) were never
   backfilled into the doc prose. Human-approved (2026-08-14) to fold this backfill into
   Task 2 rather than opening a separate story, since the doc section is already being
   edited here. Add one bullet per file, in the existing format, citing real
   currently-defined functions (verify at F4 against the actual file contents — do not
   copy these names blind):
   - `src/cli/issue/interactions.rs` — `handle_comment_add` (ADF conversion fork,
     internal flag, stdin/file/positional source resolution; extracted from `workflow.rs`
     by ADR-0012 Seam, S-577-1/PF-017)
   - `src/cli/issue/attachments.rs` — attachment list handler + `display_sanitize_filename`
     (CWE-116 display-safety sanitization; S-576-1)
   - `src/api/jira/attachments.rs` — `get_attachment_metadata`, `upload_attachments`,
     `delete_attachment`, `delete_attachment_targeted` (S-576-1/S-576-3/S-576-4)
   - `src/api/jsm/attachments.rs` — `attach_temporary_file`, `post_request_attachment`
     (JSM two-step upload; SEC-576-005 `X-Atlassian-Token`, SEC-576-006 stale-ID self-heal,
     BC-3.9.006 step-2 error taxonomy; S-576-5)
   - `src/api/jsm/servicedesks.rs` — `get_or_fetch_project_meta`, `resolve_service_desk_id`,
     `require_service_desk` (TTL logic, `project_id` string-equality match, service-desk-id
     resolution chain; S-576-5)
   After Task 2 + 2b, §Scope has exactly 18 bullets (11 pre-existing + 5 backfill + 2 new),
   matching the corrected 18-entry `examine_globs` count. The citation guard
   (`scripts/check-cargo-mutants-policy-citations.sh`) will validate every backfilled
   function name resolves in `src/` — treat a guard failure on a backfilled bullet as a
   signal to correct the bullet's function names, not to skip the guard.
3. **`Cargo.toml`**: add `libc = "0.2"` (or the exact resolved `0.2.183` if pinning is
   preferred — check repo convention for other transitive-promoted dev-deps first) under
   `[dev-dependencies]`. `libc` is already a transitive dependency (pulled in by
   tokio/reqwest on Unix; confirmed in `Cargo.lock`) but Rust requires an explicit
   `Cargo.toml` edge before `use libc::...` compiles from test code — this adds zero new
   crates to the dependency graph, only an explicit edge to an already-resolved one.
4. **`src/main.rs` — behavior-preserving refactor**: extract the `tokio::select!` block
   (currently ~line 415, inside `run()`) into a new generic async fn:
   ```rust
   pub(crate) enum RunOutcome<T> {
       Completed(T),
       Interrupted,
   }

   pub(crate) async fn run_until_shutdown<W, S, T>(work: W, shutdown: S) -> RunOutcome<T>
   where
       W: std::future::Future<Output = T>,
       S: std::future::Future<Output = ()>,
   {
       tokio::pin!(work);
       tokio::pin!(shutdown);
       tokio::select! {
           v = &mut work => RunOutcome::Completed(v),
           _ = &mut shutdown => RunOutcome::Interrupted,
       }
   }
   ```
   **Load-bearing per BC-X.3.006's VP-MUTANTS-SCOPE-1-002 description**: `eprintln!` and
   `std::process::exit(130)` stay OUTSIDE `run_until_shutdown`, at the `run()` call site —
   they do NOT move into the extracted fn (this differs from the research doc's illustrative
   Option D sketch, which is superseded by the F2-amended BC text; the BC is the authority).
   `run()`'s call site becomes approximately (ILLUSTRATIVE PSEUDOCODE ONLY — not a
   prescribed literal signature; `tokio::signal::ctrl_c()` is the real, existing tokio API,
   shown here with an inline adapter comment rather than a fabricated helper name):
   ```rust
   // PSEUDOCODE — shape only. `shutdown` must satisfy `S: Future<Output = ()>`, but
   // tokio::signal::ctrl_c() returns `impl Future<Output = std::io::Result<()>>`. The
   // exact adaptation (e.g. an inline `async { let _ = tokio::signal::ctrl_c().await; }`
   // block, or a small named wrapper fn) is an F4 implementation decision, not prescribed
   // further here — do NOT introduce a helper named `ctrl_c_ignoring_err()` or similar;
   // no such tokio API exists.
   match run_until_shutdown(main_task, async { let _ = tokio::signal::ctrl_c().await; }).await {
       RunOutcome::Completed(result) => result,
       RunOutcome::Interrupted => {
           eprintln!("\nInterrupted");
           std::process::exit(130);
       }
   }
   ```
   Byte-exact stderr and exit-code behavior MUST be unchanged (BC-X.3.006 Behavior item 2).
5. **`src/main.rs` — VP-MUTANTS-SCOPE-1-002 (portable unit test)**: add an inline
   `#[cfg(test)] mod tests` block in `src/main.rs` itself (NOT a `tests/*.rs` integration
   test file — `src/main.rs` is the binary crate's entry point, a separate compilation unit
   from the `jr` library crate that `tests/*.rs` files link against via `lib.rs`; items in
   `main.rs`, even `pub(crate)`, are not reachable from `tests/`). The test injects
   `std::future::pending::<()>()` for `work` and `std::future::ready(())` for `shutdown`,
   asserts `matches!(outcome, RunOutcome::Interrupted)`; a second test does the inverse
   (a `work` future that resolves immediately, `shutdown` pending) and asserts
   `matches!(outcome, RunOutcome::Completed(_))` — covering both arms, not just the
   interrupt arm, per BC-X.3.006's "arm-selection logic" framing (a mutant that always
   returns `Completed` regardless of which arm won must also be killable).
6. **`tests/interrupt_signal.rs` (NEW) — VP-MUTANTS-SCOPE-1-001 (out-of-process SIGINT
   test)**: `#[cfg(unix)] #[test]`, spawns `Command::new(env!("CARGO_BIN_EXE_jr"))` (raw
   `std::process::Command`, NOT `assert_cmd` — confirmed by research: `assert_cmd` exposes
   no running-`Child` handle and cannot deliver a mid-run signal), waits for a deterministic
   readiness signal via a `#[cfg(debug_assertions)]` test seam (NOT a fixed `sleep` — must
   avoid the BC-X.3.006 EC-1 registration race), sends `SIGINT` via
   `unsafe { libc::kill(child.id() as libc::pid_t, libc::SIGINT) }`, then asserts on the
   REAL child's exit code (`== 130`) and REAL stderr (`== "\nInterrupted\n"`, byte-exact).
   Per the round-15 CLAUDE.md Windows dead-code-lint lesson: gate the test AND any helper it
   alone uses (e.g. a `wait_until_ready` fn, the `libc` import) with `#[cfg(unix)]` —
   `#[cfg(unix)]`-gating only the `#[test]` fn leaves its Unix-only helpers orphaned on a
   Windows build, which `clippy --all-targets -- -D warnings` on `windows-latest` will
   hard-error on as dead code (exact mechanism that broke PR-adjacent CI in round 15 of the
   `ci_gate_completeness.rs` history — same trap, different file).
   The readiness-handshake seam design (what subcommand to invoke so the child both (a)
   reaches the `select!` before being signalled and (b) does not exit on its own before the
   signal arrives) is an F4 implementation decision within this AC's constraints — e.g. a
   `#[cfg(debug_assertions)]`-gated env var that makes `run()` print a `READY` line to
   stdout immediately after entering `run_until_shutdown`, analogous to the existing
   `JR_STDIN_IS_TTY` debug-only seam pattern.
7. Self-verify: run `docs/specs/cargo-mutants-policy.md`'s citation guard
   (`scripts/check-cargo-mutants-policy-citations.sh`) and `tests/mutants_glob_existence.rs`
   locally (or via CI) against the updated `.cargo/mutants.toml` + policy doc; run
   `cargo mutants --in-diff <diff-touching-queue.rs-or-main.rs> --jobs 4 --timeout 240`
   (or the local equivalent) to confirm the false-green is closed (a non-"0 mutants" result).

---

## Previous Story Intelligence

**S-MUTANTS-EXAMINE-GLOBS-1 (DEC-149):** Direct template for the `examine_globs`/policy-doc
half of this story. Two-file scope addition, function-location citation bullets, count-line
correction, policy-doc changelog entry. Key difference: that story made zero `src/` changes
(pure CI-config + docs); this story additionally requires a `src/main.rs` refactor and two
new tests because `main.rs`'s ctrl_c fork has zero pre-existing coverage (a defensible reason
the same file's `queue.rs` half did NOT need — `queue.rs` already has substantial existing
inline test coverage per its 592-LOC/254-inline-test-LOC composition, F1 §5).

**S-MUTANTS-SCOPE-GUARDS-1:** Built the self-verifying Guard 2 (`check-cargo-mutants-policy-citations.sh`)
and Guard 3 (`tests/mutants_glob_existence.rs::test_resolve_all_examine_globs_entries_to_real_files`)
machinery this story relies on with zero script changes. Both guards are confirmed
data-driven by F1 §4 — re-verify with `--self-test` before merging, per Task 2 above, but do
not expect to need to edit either guard file.

**S-TESTTOOL-1 (MAINT-MUTANTS-GLOBS-01):** Established the `examine_globs` addition
pattern (comment-above-each-entry convention in `.cargo/mutants.toml`) this story follows.

**Round-15 (CLAUDE.md, `ci_gate_completeness.rs` history):** `#[cfg(unix)]`-gating a test
does not remove the helper functions/imports only that test uses from a non-Unix build —
they still compile, now genuinely unused, and `-D warnings` on `windows-latest` clippy
hard-errors. This exact trap applies to `tests/interrupt_signal.rs`'s helpers (Task 6) and
is called out explicitly there — do not let it recur in a second file.

**F1 §5/§6 MEDIUM risk (main.rs kill-rate on first scoped run):** other branch-dense regions
of `main.rs` (`init_tracing`'s level selection, the `InvalidSubcommand` intercept, the
stdin-TTY auto-`no_input` flip) are believed — per F1's non-exhaustive read — to already be
covered by `tests/observability.rs`, `tests/cli_smoke.rs`, and
`tests/jr_stdin_is_tty_release_gate.rs` respectively. This story does not add new tests for
those regions; if the first real mutation run on `main.rs` surfaces survivors there, that is
explicitly F6 targeted-hardening scope, not a silent gap in this story (see Out of Scope).

---

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `examine_globs` has no sub-file targeting | F1 §5 (cargo-mutants operates at file granularity only) | `src/main.rs` must be added as a whole file, not a line-range or function subset. Accept that other branch-dense `main.rs` regions become mutation targets too (tracked risk, see Previous Story Intelligence). |
| `#[mutants::skip]` is rejected for the ctrl_c fork | BC-X.3.006 Verification Properties ("Explicitly rejected"); `docs/specs/cargo-mutants-policy.md §Whitelist Convention` | "Hard to test"/"tests don't cover this" are explicitly invalid justifications repo-wide. No skip attribute may be added to `run_until_shutdown`, the ctrl_c arm, or `run()`'s interrupt branch as a substitute for Tasks 4–6. |
| `eprintln!`/`process::exit(130)` stay at the `run()` boundary | BC-X.3.006 VP-MUTANTS-SCOPE-1-002 (authoritative over the research doc's illustrative sketch) | `run_until_shutdown` must return `RunOutcome`, not perform the side effect itself — this is what keeps the fn unit-testable without `process::exit` tearing down the test harness. |
| `main.rs` items are unreachable from `tests/*.rs` | Rust binary-vs-library crate separation (confirmed by reading `src/lib.rs`'s "re-exports for integration tests" role vs. `src/main.rs`'s standalone-binary role) | VP-MUTANTS-SCOPE-1-002's test MUST be an inline `#[cfg(test)] mod tests` inside `src/main.rs`, not a new `tests/*.rs` file. Do not attempt to re-export `run_until_shutdown` through `lib.rs` to make it reachable from `tests/` — that would be a structural change out of scope for this story. |
| `#[cfg(unix)]`-gate helpers, not just the test fn | Round-15 CLAUDE.md lesson (Windows dead-code-lint hazard) | Every helper (readiness-wait fn, `libc` import) used exclusively by `tests/interrupt_signal.rs`'s Unix-gated test must itself carry `#[cfg(unix)]`. |
| `--in-diff` + `examine_globs` double-gate unchanged | `docs/specs/cargo-mutants-policy.md §CI Integration` | No `.github/workflows/ci.yml` change is needed or permitted by this story — the `mutants` job's invocation is scope-agnostic and reads `examine_globs` at run time. |
| No fixed `sleep` in the readiness handshake | BC-X.3.006 EC-1; research doc "Why refactor alone is insufficient" | The SIGINT test's readiness wait must be a deterministic handshake (debug-only seam, pipe, or similar), never `std::thread::sleep`/`tokio::time::sleep` used as a proxy for "the child is ready." |

---

## Library & Framework Requirements

| Tool/Crate | Version | Constraint |
|------|---------|-----------|
| `libc` | `0.2.183` (already resolved transitively in `Cargo.lock` via tokio/reqwest on Unix) | Add as an explicit `[dev-dependencies]` entry in `Cargo.toml` (`libc = "0.2"` or pinned to the resolved patch — check repo convention for other transitively-promoted deps before choosing). Adds ZERO new crates to the dependency graph. Do NOT add `nix` (would be a genuinely new dependency; research doc's fallback-only option 3) or `rexpect` (MSRV 1.85.0 exactly, zero headroom — research doc's explicit Reject). |
| `cargo-mutants` | `@27` (pinned in `ci.yml`, unchanged) | No version change. Scope widening does not require a bump. |
| `tokio` | repo-pinned version (see `Cargo.toml`), `test-util`/macros features already enabled | `tokio::pin!`, `tokio::select!`, `#[tokio::test]`, `std::future::{ready, pending}` are all already available; no new tokio feature flags needed. |

No `Cargo.lock`-visible new crate entries are expected from this story (only an explicit
`Cargo.toml` edge to an already-resolved transitive dependency).

---

## File Structure Requirements

| File | Create / Modify | Description |
|------|-----------------|-------------|
| `.cargo/mutants.toml` | MODIFY | Add `"src/cli/queue.rs"` + `"src/main.rs"` to `examine_globs` (16→18) with inline comments (Task 1). |
| `docs/specs/cargo-mutants-policy.md` | MODIFY | §Scope: two new bullets (Task 2) PLUS five backfilled bullets for pre-existing undocumented entries (Task 2b, AC-014, M-1) + count-line correction 16→18. |
| `Cargo.toml` | MODIFY | Add `libc` under `[dev-dependencies]` (Task 3). |
| `src/main.rs` | MODIFY | Extract `run_until_shutdown` + `RunOutcome`; update `run()`'s call site; add inline `#[cfg(test)] mod tests` for VP-MUTANTS-SCOPE-1-002 (Tasks 4–5). |
| `tests/interrupt_signal.rs` | CREATE | `#[cfg(unix)]` out-of-process SIGINT test for VP-MUTANTS-SCOPE-1-001 (Task 6). |

No other file is expected to require a change. `scripts/check-cargo-mutants-policy-citations.sh`
and `tests/mutants_glob_existence.rs` are self-verifying (F1 §4) — do not edit either unless
the self-test dry run in Task 2/7 reveals an actual citation-resolution failure.

---

## Acceptance Criteria

### AC-001 — `.cargo/mutants.toml::examine_globs` contains exactly the two new entries (18 total)
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN)

After the change, `.cargo/mutants.toml::examine_globs` contains ALL 16 pre-existing entries
plus exactly `"src/cli/queue.rs"` and `"src/main.rs"` (18 total), each preceded by an inline
`#` comment matching the file's existing convention (comment-above-entry, HIGH-value
rationale, story/decision citation). No pre-existing entry is removed or reordered in a way
that breaks the file's readability.

---

### AC-002 — `docs/specs/cargo-mutants-policy.md` §Scope gains this story's two new bullets and the count line is corrected
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN)

§Scope contains two new bullets FOR THIS STORY'S OWN `examine_globs` ADDITIONS, one per file,
each citing real currently-defined functions: `src/cli/queue.rs` → `handle`, `handle_list`,
`handle_view`, `resolve_queue_by_name`, `extra_fields_allow_list`, `is_customfield_token`,
`reorder_by_queue_position`, `collapse_and_truncate`; `src/main.rs` → `init_tracing`, `run`,
`run_until_shutdown`. The "Current `examine_globs` count" line reads 18, not 16. This AC
covers ONLY these 2 bullets — the 5 additional backfill bullets for pre-existing undocumented
entries are AC-014's scope, not this AC's; the two ACs are checked together (both must pass)
to reach the 18-bullets-for-18-entries end state, and neither is redundant with the other.

---

### AC-003 — `scripts/check-cargo-mutants-policy-citations.sh` (canonical, non-self-test mode) passes with zero offenders
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN)

Running the script in canonical mode against the updated policy doc + `src/` tree reports
zero `BC-CITE-001`-class (or this script's equivalent) offenders. In particular, the citation
resolver correctly locates `async fn run(cli: Cli) -> anyhow::Result<()>`,
`fn init_tracing(cli: &Cli)`, and the newly-added `run_until_shutdown` free function in
`src/main.rs` — this is the one item F1 §4 flagged as worth a dry-run confirmation rather
than a known pass.

---

### AC-004 — `tests/mutants_glob_existence.rs::test_resolve_all_examine_globs_entries_to_real_files` passes
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN)

Both new glob entries resolve to real files via `glob::glob()` expansion. The
`MUTANTS-GLOBS-COVERAGE-FLOOR` (`FLOOR: usize = 11`) is unaffected — 18 stays well above the
floor, and the floor only fires on removal below 11, never on addition.

---

### AC-005 — A `cargo-mutants --in-diff` run touching `queue.rs`/`main.rs` reports a non-"0 mutants" result
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN)

A local (or CI) `cargo-mutants --in-diff <diff> --jobs 4 --timeout 240` dry run against a
synthetic or real diff touching `src/cli/queue.rs` and/or `src/main.rs` produces a result
report with `total_mutants > 0` for the touched file(s) — proving the false-green
(`MUTANTS-SCOPE-GAP-QUEUE-MAIN`) is closed, not just that the config file was edited.

**Bar actually met (recorded, not just "non-zero"; M-1 tightening):** the authoritative run
on final branch HEAD `37ac5e41` achieved caught=3, missed=0, unviable=4, timeout=0 — a
**≥90% kill rate over viable mutants (actually 100%)**, with **0 timeout survivors** on the
delivered branch. This includes the seam-selection condition mutant
(`src/main.rs:490 replace == with != in run`) — the specific "hang survivor" class this AC's
`--timeout 240` framing exists to guard against — caught via a fast test failure, not a
timeout. See the Regression Risk table row "THIS STORY'S OWN new seam-selection scaffolding"
for the full breakdown.

---

### AC-006 — `run_until_shutdown(work, shutdown) -> RunOutcome<T>` exists with the exact signature and boundary contract
(traces to BC-X.3.006 Behavior item 1; VP-MUTANTS-SCOPE-1-002)

`src/main.rs` defines `enum RunOutcome<T> { Completed(T), Interrupted }` and an async fn
`run_until_shutdown<W, S, T>(work: W, shutdown: S) -> RunOutcome<T>` (generic over
`W: Future<Output = T>`, `S: Future<Output = ()>`). The fn contains NO `eprintln!` call and
NO `std::process::exit` call — both remain at the `run()` call site, matching
BC-X.3.006 VP-MUTANTS-SCOPE-1-002's boundary contract (which supersedes the research doc's
illustrative sketch that had put `eprintln!` inside the fn).

---

### AC-007 — `run()`'s observable behavior is byte-for-byte unchanged on both the completed and interrupted paths
(traces to BC-X.3.006 Behavior item 2)

For the `main_task`-wins path: `run()`'s return value is identical before and after the
refactor (no change to any command's exit code or output). For the `ctrl_c`-wins path:
stderr is exactly `"\nInterrupted\n"` (byte-exact) and the process exit code is exactly
`130`, identical to pre-refactor behavior. No cleanup/drop-order behavior is introduced
between the interrupt detection and `process::exit` (BC-X.3.006's "no cleanup runs between
steps 1 and 2" note is preserved, not newly violated).

---

### AC-008 — VP-MUTANTS-SCOPE-1-002: portable `#[tokio::test]` covers BOTH arms of `run_until_shutdown`
(traces to BC-X.3.006 Verification Properties; VP-MUTANTS-SCOPE-1-002)

An inline `#[cfg(test)] mod tests` block inside `src/main.rs` (NOT a `tests/*.rs` file — see
Architecture Compliance Rules) contains at least two `#[tokio::test]` functions:
1. Injects `std::future::pending::<()>()` for `work` and `std::future::ready(())` for
   `shutdown`; asserts `matches!(outcome, RunOutcome::Interrupted)`.
2. Injects an immediately-resolving future for `work` and `std::future::pending::<()>()` for
   `shutdown`; asserts `matches!(outcome, RunOutcome::Completed(_))`.
Both tests run on every platform (no signal delivery involved) and are included in the
default `cargo test` run (no `#[ignore]`, no feature gate).

---

### AC-009 — VP-MUTANTS-SCOPE-1-001: `#[cfg(unix)]` subprocess test observes the REAL exit code and REAL stderr
(traces to BC-X.3.006 Verification Properties; VP-MUTANTS-SCOPE-1-001)

`tests/interrupt_signal.rs` contains a `#[cfg(unix)] #[test]` function that: spawns the
compiled `jr` binary via `std::process::Command` (not `assert_cmd`); sends `SIGINT` via
`libc::kill(pid, libc::SIGINT)`; collects the child's real exit status and real stderr; and
asserts `exit_code == Some(130)` and `stderr == "\nInterrupted\n"` byte-exact — the same
contract as AC-007, now verified out-of-process rather than by code inspection.

---

### AC-010 — The SIGINT test uses a deterministic readiness handshake, never a fixed sleep
(traces to BC-X.3.006 Edge Case EC-1)

The `tests/interrupt_signal.rs` test does not use `std::thread::sleep`/`tokio::time::sleep`
(or any fixed-duration wait) as its sole mechanism for determining the child process is ready
to receive `SIGINT`. It uses a deterministic signal (e.g. a `#[cfg(debug_assertions)]`-gated
readiness marker written by the child once it has entered `run_until_shutdown`, analogous to
the existing `JR_STDIN_IS_TTY` debug-only test-seam pattern) before sending the signal — this
is the documented mitigation for the EC-1 registration race (`tokio::signal::ctrl_c()` only
registers its OS listener on first poll).

---

### AC-011 — `#[cfg(unix)]`-only helpers in `tests/interrupt_signal.rs` are themselves `#[cfg(unix)]`-gated
(traces to BC-X.3.006 Verification Properties — VP-MUTANTS-SCOPE-1-001 correctness; round-15 CLAUDE.md lesson)

Any helper function, constant, or `use libc::...` import in `tests/interrupt_signal.rs` that
is referenced only by the `#[cfg(unix)]`-gated test is itself annotated `#[cfg(unix)]` (or
placed inside a `#[cfg(unix)] mod` block). `cargo clippy --all-targets --all-features -D
warnings` produces zero dead-code warnings for this file on a non-Unix target (verified per
the repo's existing round-15 remediation pattern — reproduce via a standalone
target-triple-scoped clippy/rustc check if a Windows runner is unavailable, matching the
verification method already established in CLAUDE.md's round-15 history).

---

### AC-012 — No `src/` production behavior changes outside the documented `run_until_shutdown` refactor
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN; BC-X.3.006)

`src/cli/queue.rs` is NOT edited by this story — it becomes a mutation-testing target only
(examine_globs addition), its behavior is unchanged. `src/main.rs`'s only behavioral-code
change is the `run_until_shutdown` extraction described in AC-006/AC-007; no other function
in `main.rs` (`init_tracing`, the dispatch `match`, the `InvalidSubcommand` intercept, the
stdin-TTY flip, the post-`run()` error-mapping block) is modified.

---

### AC-013 — Human decision on the `main.rs` kill-rate risk is recorded, not silently defaulted
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN — F1 §7 AC-seed #6)

This story implements F1 AC-seed #6 option (b): "write a new signal-based subprocess test in
the same story" (VP-MUTANTS-SCOPE-1-001 + VP-MUTANTS-SCOPE-1-002), as recorded in this
story's `origin:` frontmatter field and in the Previous Story Intelligence section above. Any
residual kill-rate gap from OTHER branch-dense regions of `main.rs` not touched by this story
(see Out of Scope) is explicitly deferred to F6 targeted hardening, not silently absorbed.

**F6-deferral scope correction (M-1, pass-4 adversary, verification-accounting):** the F6
deferral above applies ONLY to the PRE-EXISTING branch-dense regions named in Out of Scope
(`init_tracing`'s level selection, the `InvalidSubcommand` intercept, the stdin-TTY
auto-`no_input` flip). It does NOT extend to this story's OWN newly-added seam-selection
scaffolding in `run()` (the `test_seam_active` env-read/condition, the work/shutdown boxing
fork, the production `ctrl_c()` adapter) — those are new in-diff lines introduced BY this
story, so `cargo mutants --in-diff` mutates them as part of THIS story's own scope, not F6's.
That scaffolding is in this story's own mutation scope, not deferred: the authoritative run
on final branch HEAD `37ac5e41` reports caught=3, missed=0, unviable=4, timeout=0 (100% kill
rate over viable mutants, 0 timeout survivors) for the seam-selection condition and the
seam/`run` bodies. The production `ctrl_c()` adapter line itself generated no viable mutant
and is exercised by no test (VP-MUTANTS-SCOPE-1-001 drives the `test_seam_active` seam, not
the real adapter call) — this is a documented no-mutant residual, not affirmative coverage;
see the Regression Risk table's pass-5 correction and the AC-005 note above for the full,
precise breakdown.

---

### AC-014 — `docs/specs/cargo-mutants-policy.md` §Scope documents ALL `examine_globs` entries, not just this story's 2 new ones
(traces to drift item MUTANTS-SCOPE-GAP-QUEUE-MAIN — pre-F4 consistency audit finding M-1, human-approved 2026-08-14)

`docs/specs/cargo-mutants-policy.md` §Scope documents ALL `examine_globs` entries — the 5
pre-existing undocumented entries (`interactions.rs`, `cli/issue/attachments.rs`,
`api/jira/attachments.rs`, `api/jsm/attachments.rs`, `api/jsm/servicedesks.rs`) are backfilled
with correctly-formatted, real-function-citing bullets in the same edit as this story's 2 new
bullets (Task 2b), so the doc has exactly 18 bullets matching 18 `examine_globs` entries and
the "Current `examine_globs` count" line (18) is no longer misleading. This is pure
mutation-scope-doc governance — no BC governs it (same as AC-001/AC-002/AC-003/AC-004/AC-005).
The implementer verifies each backfilled bullet's function citations against the actual file
contents at F4 (names in Task 2b are a starting point, not a guarantee); the citation guard
(`scripts/check-cargo-mutants-policy-citations.sh`, canonical non-self-test mode, same
invocation as AC-003) is the acceptance mechanism — zero offenders across all 18 bullets
(this story's 2 plus the 5 backfilled plus the 11 pre-existing) is the pass condition.

---

## Regression Risk

| Area | Risk | Rationale |
|------|------|-----------|
| PRs not touching `queue.rs`/`main.rs` | NONE | `--in-diff` bounds mutation cost to changed lines; zero new mutants on unrelated PRs. |
| `queue.rs` first scoped mutation run | LOW | F1 §5 estimates ~15–30 mutants; `collapse_and_truncate` already has F6-hardened boundary tests (PR #700); no code change in this story. |
| `main.rs` first scoped mutation run, `run_until_shutdown` region specifically | LOW (after this story) | VP-001/VP-002 together kill the exit-code literal, `eprintln!` deletion, and arm-swap mutant classes — the three mutants F1 §5 specifically flagged as otherwise-guaranteed survivors. |
| `main.rs` first scoped mutation run, THIS STORY'S OWN new seam-selection scaffolding in `run()` (`~src/main.rs:488-522`: the `test_seam_active` env-read/condition, the work/shutdown boxing fork, the production `ctrl_c()` adapter) | RESOLVED for the seam-selection condition and the seam/`run` bodies (empirically verified, not deferred); the production `ctrl_c()` adapter line is an ACKNOWLEDGED, DOCUMENTED RESIDUAL — no mutant generated, not affirmatively test-covered | M-1 correction (pass-4 adversary): this scaffolding is newly-added IN-DIFF code, so it is IN-SCOPE for `cargo mutants --in-diff` on THIS story — it is NOT covered by the AC-013/F6 deferral, which applies only to the PRE-EXISTING branch-dense regions (`init_tracing`, `InvalidSubcommand`, stdin-TTY flip) named in the row below. Authoritative empirical result, run on final branch HEAD `37ac5e41`: `cargo mutants --in-diff` → caught=3, missed=0, unviable=4, timeout=0 — **100% kill rate over viable mutants, zero timeout/hang survivors**. Caught: `src/main.rs:194 replace block_until_sigint_test_seam with ()`; `src/main.rs:220 replace run -> anyhow::Result<()> with Ok(())`; `src/main.rs:490 replace == with != in run` (the seam-selection condition itself — the exact "hang survivor" class M-1 flagged as a risk — caught via a fast test failure, NOT a timeout). Unviable (don't compile, expected, not a coverage gap): 4× `src/main.rs:172 replace run_until_shutdown -> RunOutcome<T> with RunOutcome::{new/from/from_iter/...}`. **Pass-5 correction (LOW, precision-only):** none of the three caught mutants above touches the production `tokio::signal::ctrl_c()` adapter line itself (`~src/main.rs:515-522`). VP-MUTANTS-SCOPE-1-001's subprocess test always drives the SEAM (`test_seam_active` → `signal()`) path, never the real `ctrl_c()` call, so that line is exercised by no test in this suite; cargo-mutants correspondingly generated NO viable mutant on it (a bare `let _ = tokio::signal::ctrl_c().await;` has no return value or operator left to mutate once the seam absorbs the condition). "No mutant generated" is a **vacuously-true absence of surviving-mutant risk**, not affirmative test coverage of that line — the caught=3/missed=0 result must not be read as proving the `ctrl_c()` adapter itself is regression-protected. This mirrors BC-X.3.006's own existing race-condition/residual note (`.factory/specs/prd/cross-cutting.md` — "Race condition (documented, not a defect)") that already documents this line as outside VP-MUTANTS-SCOPE-1-001's reach. The overall "no surviving-mutant risk / mergeable" conclusion for this story is unchanged — this is a status-label precision fix, not a new blocking finding. |
| `main.rs` first scoped mutation run, OTHER PRE-EXISTING regions (`init_tracing`, `InvalidSubcommand`, stdin-TTY flip) | MEDIUM (carried forward, not closed by this story) | F1 §5/§6's highest-attention item; believed covered by existing tests (`tests/observability.rs`, `tests/cli_smoke.rs`, `tests/jr_stdin_is_tty_release_gate.rs`) but not exhaustively verified. Explicitly deferred to F6 (AC-013). This deferral is scoped to these PRE-EXISTING regions only — see the row above for this story's own new lines, which are empirically resolved, not deferred. |
| `--timeout 240` per-mutant ceiling | LOW | Neither file has real wall-clock sleeps or wiremock long-polls (the documented root cause of the original MUTATION-CI-TIMEOUT incident, which was in `bulk.rs`). |
| Combined CI-duration/timeout-minutes ceiling | LOW | F1 §5 estimates ~25–50 combined mutants for a PR touching both files — roughly half the "typical adf.rs PR" (~80) tier, far below the 400+ oversized-diff signal. |
| `libc` dev-dependency addition | NONE | Already resolved transitively (Cargo.lock); `cargo deny check` has no new license/vulnerability surface to evaluate. |
| Guard 2 / Guard 3 self-verifying machinery | VERY LOW | Both confirmed data-driven (F1 §4); re-verify with `--self-test` + a real-mode dry run before merging per Task 2/7, not expected to require edits. |

---

## Out of Scope (explicit)

**Closing the full `main.rs` kill-rate gap.** This story closes the highest-confidence,
zero-coverage region (the ctrl_c/SIGINT fork). It does NOT add new tests for
`init_tracing`'s level selection, the `InvalidSubcommand` intercept, the stdin-TTY
auto-`no_input` flip, or the post-`run()` error-mapping block — those are believed already
covered by existing tests (Previous Story Intelligence) but not re-verified line-by-line
here. If the first real mutation run on `main.rs` post-merge surfaces survivors in those
regions, closing them is F6 targeted-hardening scope (AC-013), not a silent expectation on
this story.

**`.github/workflows/ci.yml` changes.** The `mutants` job's invocation is scope-agnostic
(reads `examine_globs` at run time); no CI YAML edit is required or in scope.

**A Windows-specific Ctrl+C integration test.** `tokio::signal::ctrl_c()` is itself portable
(maps to Windows `CTRL_C_EVENT`), but delivering a Windows-equivalent signal from a test is a
fundamentally different mechanism, not currently exercised anywhere in this repo, and is not
a supported contract this story adds. VP-MUTANTS-SCOPE-1-001 is Unix-scoped by design (it
still runs on the `mutants` CI job's `ubuntu-latest` runner, so it counts toward the kill
rate that matters for the gate).

**`#[mutants::skip]` or `exclude_globs` for any part of the ctrl_c fork.** Rejected by
BC-X.3.006 itself and by `docs/specs/cargo-mutants-policy.md §Whitelist Convention` — see
Architecture Compliance Rules.

**Re-exporting `run_until_shutdown` through `lib.rs`.** Not needed — VP-MUTANTS-SCOPE-1-002's
test lives inline in `src/main.rs` (see Architecture Compliance Rules). Making `main.rs`
internals reachable from `tests/*.rs` would be an unrelated structural change.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `examine_globs` scope config | `.cargo/mutants.toml` | N/A (config) | Adds `queue.rs` + `main.rs` to the mutation file scope; no executable-code change on its own. |
| Policy doc §Scope table | `docs/specs/cargo-mutants-policy.md` | N/A (documentation) | Two new function-location bullets + count-line correction. |
| `run_until_shutdown` / `RunOutcome` | `src/main.rs` | Effectful (async future orchestration; awaits caller-supplied futures) but produces no side effect itself — `eprintln!`/`process::exit` stay at the `run()` boundary per BC-X.3.006 VP-002 | Deliberately kept minimal so it is unit-testable via injected `std::future::{ready,pending}` without tearing down the test harness. |
| `run()` call site update | `src/main.rs` | Effectful (owns the process-terminating side effect) | Matches on `RunOutcome` and performs `eprintln!`/`process::exit(130)` — the one part of this region that structurally cannot be unit-tested in-process (BC-X.3.006). |
| VP-MUTANTS-SCOPE-1-002 test | `src/main.rs` (inline `#[cfg(test)] mod tests`) | Pure (deterministic future resolution, no I/O, no signals) | Cross-platform arm-selection coverage. |
| VP-MUTANTS-SCOPE-1-001 test | `tests/interrupt_signal.rs` (new) | Effectful (spawns a real OS process, sends a real signal) | The only test shape that can observe `main.rs`'s actual process-boundary contract. |
| `queue.rs` mutation target | `src/cli/queue.rs` | N/A (not edited — becomes a mutation target only) | See AC-012. |

**Subsystem anchor justification:** SS-01 owns `src/main.rs` (dispatch/runtime entry point)
per ARCH-INDEX Subsystem Registry — this story's only code edit lives here. SS-08 owns
`src/cli/queue.rs` (JSM queue commands) per ARCH-INDEX Subsystem Registry — listed because
it enters this story's `examine_globs` scope addition, even though no code in it changes.

**Dependency anchor justification:** `depends_on: []` — all prerequisite mutation-gate
infrastructure (S-346, S-MUTATION-CI-TIMEOUT-1, S-TESTTOOL-1, S-MUTANTS-EXAMINE-GLOBS-1,
S-MUTANTS-SCOPE-GUARDS-1) is already merged, and this story's `src/main.rs` refactor has no
other story depending on its internal shape. `blocks: []` — no other story is known to depend
on `run_until_shutdown`'s existence or on `queue.rs`/`main.rs` entering `examine_globs`.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-X.3.006 EC-1 | `SIGINT` arrives before `run_until_shutdown`'s `select!` first polls | Falls through to OS default disposition (process terminates by signal, not via the graceful path) — the readiness handshake in AC-010 is designed to avoid triggering this window, not to test it | AC-009, AC-010 |
| EC-002 | BC-X.3.006 EC-2 | `SIGINT` arrives after `main_task` already won the race | Unreachable — `select!` only polls remaining arms until one resolves; not directly exercised by a new test | (documented only) |
| EC-003 | BC-X.3.006 EC-3 | `SIGINT` during a `--output json` invocation | Still plain-text `"\nInterrupted\n"` on stderr, never the JSON error envelope — pre-existing asymmetry, unaffected by this story, not re-tested here | (documented only) |
| EC-004 | F1 §5 | PR touches only `queue.rs` (not `main.rs`) | Gate runs `queue.rs`'s ~15–30 mutants only; `main.rs`'s new entry contributes 0 mutants to that diff | AC-001, AC-005 |
| EC-005 | F1 §5 | PR touches only `main.rs` (not `queue.rs`) | Gate runs `main.rs`'s mutants (including the now-covered ctrl_c fork); `queue.rs`'s new entry contributes 0 mutants to that diff | AC-001, AC-005 |
| EC-006 | Round-15 CLAUDE.md history | `tests/interrupt_signal.rs` compiled on a non-Unix target | `#[cfg(unix)]`-gated test and all its exclusive helpers vanish together; zero dead-code warnings under `-D warnings` | AC-011 |
| EC-007 | Research doc "Why refactor alone is insufficient" | A mutant deletes `eprintln!("\nInterrupted")` at the `run()` call site (outside `run_until_shutdown`) | Killed by VP-MUTANTS-SCOPE-1-001 (real stderr observation) only — VP-MUTANTS-SCOPE-1-002 cannot see this, by design (see AC-006/AC-008 boundary contract) | AC-009 |
| EC-008 | Research doc "Why refactor alone is insufficient" | A mutant changes `std::process::exit(130)`'s literal to another value | Killed by VP-MUTANTS-SCOPE-1-001 (real exit-code observation) only | AC-009 |

---

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|----------------|
| `.cargo/mutants.toml` | N/A (config) | CI configuration file, not Rust source. |
| `docs/specs/cargo-mutants-policy.md` | N/A (documentation) | Policy document. |
| `Cargo.toml` | N/A (config) | Manifest file. |
| `run_until_shutdown` (`src/main.rs`) | Effectful, minimally so | Awaits caller-supplied futures (I/O-bound by nature of `Future`), but performs no observable side effect itself — no `eprintln!`, no process termination, no allocation beyond the enum return. The `RunOutcome` enum itself is a pure data type. |
| `run()`'s updated call site (`src/main.rs`) | Effectful | Owns the process-terminating side effect (`eprintln!` + `process::exit`) that structurally cannot be made pure (it must actually terminate the process). |
| `tests/interrupt_signal.rs` | Effectful (test code) | Spawns a real OS process and sends a real signal — inherently effectful, appropriately isolated in a dedicated integration-test file rather than mixed into the unit-test-style `#[cfg(test)] mod tests` block. |

---

## Story Points and Effort

**5 story points.**

Breakdown:
- `.cargo/mutants.toml` + policy-doc scope addition (Tasks 1–2, mirrors S-MUTANTS-EXAMINE-GLOBS-1's 2-file governance pattern): 1 SP
- `Cargo.toml` dev-dependency addition (Task 3): 0.25 SP
- `run_until_shutdown` extraction + `run()` call-site update, behavior-preserving (Task 4): 1.5 SP
- VP-MUTANTS-SCOPE-1-002 portable unit test, both arms (Task 5): 0.5 SP
- VP-MUTANTS-SCOPE-1-001 out-of-process SIGINT test + readiness-handshake seam + `#[cfg(unix)]` hygiene (Task 6, the highest-uncertainty item per the research doc's own "residual risk: the signal-registration race" callout): 1.75 SP

Comparable stories: `S-MUTANTS-EXAMINE-GLOBS-1` (2 SP, CI-config + docs only, no `src/`
change); this story is larger because it additionally requires a behavior-preserving `src/`
refactor and a new out-of-process signal test with a non-trivial readiness-handshake design.

## Close-Out (v1.1, 2026-08-14)

**CONVERGED, DELIVERED, MERGED, CLOSED.**

- Implemented on branch `test/mutants-scope-queue-main`, full VSDD Feature Mode pipeline
  F1–F7, standalone cycle (not part of a bundle). F1 delta analysis, a dedicated research
  pass (ctrl_c mutation-testing approach), F2 spec evolution (BC-X.3.006 amended in place,
  VP-MUTANTS-SCOPE-1-001/002 minted inline), a pre-F4 consistency audit (CLEAN; folded in
  AC-014 to backfill 5 undocumented pre-existing `examine_globs` entries), F3 story
  decomposition (this file, 14 ACs).
- F4 delta implementation: extracted the behavior-preserving `run_until_shutdown(work,
  shutdown) -> RunOutcome<T>` helper from `run()`'s `tokio::select!` ctrl_c fork in
  `src/main.rs`; added the `#[cfg(all(debug_assertions, unix))]` test-readiness seam;
  `.cargo/mutants.toml examine_globs` 16→18 (`src/cli/queue.rs`, `src/main.rs`); 5 §Scope
  backfill bullets + 1 policy-doc Changelog row in `docs/specs/cargo-mutants-policy.md`;
  new tests `tests/interrupt_signal.rs` (VP-MUTANTS-SCOPE-1-001, `#[cfg(unix)]` subprocess
  SIGINT test via `libc::kill`) and an inline portable `#[tokio::test]` arm-selection unit
  test (VP-MUTANTS-SCOPE-1-002) plus `tests/jr_test_block_until_sigint_release_gate.rs`;
  `libc` promoted to an explicit `[dev-dependencies]` edge; CLAUDE.md test-seam bullet added.
  AC-005 delta mutation: 3/3 caught, 0 missed, 4 unviable, 0 timeout — 100% viable kill rate.
- **F5 scoped adversarial review CONVERGED to the STRICT DEC-245 bar** (human-directed): 12
  total passes, 3 consecutive clean passes (10/11/12), 0 CRIT/HIGH across all 12; the sole
  pass-1 HIGH finding (a duplicated interrupt branch in the seam) was fixed same-pass and
  never recurred.
- F6 targeted hardening: delta mutation testing 100% viable kill (see F4 above); full-tree
  regression GREEN — authoritative source is the `develop`-push CI run `31834348241` @
  `a2a7749e` (success, including E2E success) plus PR #702's own CI (15/15 green); security
  scans green; formal-verify/fuzz correctly judged N/A (CI-config + refactor change, no new
  attack surface).
- F7 delta convergence: **5/5 dimensions PASS** (D1 spec, D2 test, D3 impl, D4 verify, D5
  holdout N/A-for-infra) plus a full-tree regression confirmation.
- **PR #702 MERGED to `develop` as `a2a7749e`.** Merged via GitHub UI using the **merge-commit
  strategy**, not the repo's usual squash convention (human action; deviation noted, left in
  place, being fixed forward via `ADOPT-MERGE-METHOD-RULESETS` rather than reverted or
  rewritten). Code content is identical/correct either way; the 15 feature commits
  (`627021ae`…`c0fa930c`) are now part of `develop`'s history verbatim rather than squashed
  into one. pr-reviewer verdict APPROVE (`covered_sha` `c0fa930c`), COMMENT-state only
  (reviewer==author — `VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER`, recurrence
  logged). Worktree `.worktrees/S-MUTANTS-SCOPE-1` and its branch removed post-merge.
- Drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN` (MEDIUM) — **RESOLVED**, delivered and merged in
  `a2a7749e`; `queue.rs`/`main.rs` are now both inside `examine_globs`.
- Process-gap findings recorded during delivery: `PR-MANAGER-COMPLETION-GUARD-STEP10-LOOP`
  (NEW, LOW) — pr-manager's SubagentStop completion guard oscillated demanding a nonexistent
  step 10 when steps 8/9 were justifiably `status=na` per DEC-128; recovered via a fresh
  pr-reviewer dispatch + `TaskStop`. `CLIPPY-RELEASE-ALL-TARGETS-PREEXISTING-CONST-EVAL-FAIL`
  (NEW, LOW, pre-existing, unrelated to this story) — `cargo clippy --release --all-targets`
  fails repo-wide on a const-eval assertion in `tests/config_dir_release_gate.rs`, reproduced
  on the base branch; CI does not run that combination. `PR-MANAGER-RETURNS-BLOCKED-WITHOUT-
  AWAITING-GRANDCHILDREN` and `VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER` both
  RECURRED on PR #702 (fourth/fourth occurrences respectively); `FACTORY-DISPATCHER-
  POSTTOOLUSE-HOOK-TIMEOUT` recurred on F4/F5 artifact edits. New follow-up drift item
  `ADOPT-MERGE-METHOD-RULESETS` (MEDIUM) opened to configure per-target-branch GitHub merge-
  method Rulesets, the systemic fix for both the #702 merge-commit deviation and the
  pre-existing `POST-RELEASE-BACKMERGE-SQUASH-BREAKS-ANCESTRY` item.
- No BC/VP count change from F3 onward (BC-X.3.006 amendment only, minted in F2); total_bcs
  unchanged. `STORY-INDEX.md` total_stories 132→133 (this story is new), status row
  `draft`→`done`.

Full detail: `STATE.md`, `cycles/cycle-001/burst-log.md` § S-MUTANTS-SCOPE-1-CLOSED,
`cycles/cycle-001/decisions-archive.md` DEC-277.
