---
document_type: lessons-learned
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-11T21:00:00Z
cycle: "cycle-007-auth-correctness-dx"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-007 (auth-correctness-dx)

<!-- Durable lessons from this cycle for future VSDD factory runs.
     Organized by category: agent-level, process-level, infrastructure-level.
     Each lesson is numbered continuously and includes the pass/burst
     where it was discovered.
     Process-gap findings (cycle-closing checklist S-7.02): PG-A1 through PG-A4,
     captured at Story A Step-4.5 adversarial convergence (2026-09-11, 9 passes). -->

## Agent-Level

1. **[PG-A1] Doc-sweep grep pattern cannot match angle-bracket placeholders in rustdoc/prose** —
   The doc-sweep grep used brace/backtick pattern matching to find stale remediation strings, but
   could not match the `<profile>` angle-bracket placeholder form used in `///` rustdoc comments
   and `.md` prose files. Stale `jr auth login <profile>` positional docs survived to pass 1.
   Remedy: remediation-string sweeps must add an explicit grep for the angle-bracket placeholder
   form AND cover `.md` files and rustdoc prose, not just `.rs` error-message strings.
   _Discovered: Story A Step-4.5 Pass 1, 2026-09-11. [process-gap]_
   _Follow-up: Justified deferral — fold into next session-review / CLAUDE.md sweep doc update._

## Process-Level

2. **[PG-A2] Rename-reconciliation instructions must sweep the entire test cluster, not a single helper** —
   Task 7a's "`_exit_64` name is itself a defect" principle was scoped to renaming a single helper.
   Test function names, `///` docstrings, and `//` inline comments throughout the cluster retained
   the old terminology, requiring a full-cluster re-sweep in pass 2. Remedy: every
   rename-reconciliation sweep must explicitly enumerate test function names, docstrings, and inline
   comments in all files touched — not just the named helper.
   _Discovered: Story A Step-4.5 Pass 2, 2026-09-11. [process-gap]_
   _Follow-up: Justified deferral — fold into session-review checklist update._

3. **[PG-A3] Equals-form remediation string must propagate to ALL quoted-string sites atomically** —
   When a remediation string changes form (space-form -> equals-form), ALL sites must update in one
   atomic pass: production code, test helper constants, spec oracle literals, rustdoc, CHANGELOG.
   Pass 4 found 12 keyring-gated (`#[ignore]`) expected-message helpers still holding the old
   space-form string; default `cargo test` stayed green (silent false-green). Remedy: run
   `grep -r "<old-string>"` across `src/`, `tests/`, `.factory/specs/`, and `CHANGELOG.md` before
   declaring propagation complete; explicitly include `#[ignore]`-gated test helpers in the sweep.
   _Discovered: Story A Step-4.5 Pass 4, 2026-09-11. [process-gap] CRITICAL_
   _Follow-up: Follow-up story candidate — CI guard comparing production error constants against_
   _test helper constants. Deferred to cycle-008+ / maintenance sweep._

4. **[PG-A4] Completeness-sweep instructions must carry an explicit scope fence** —
   An instruction to "sweep all equals-form sites" without an explicit scope fence caused the agent
   to update out-of-scope functions (`load_oauth_tokens`, `auth logout`) and a released changelog
   section, requiring a revert commit (c912b489). Remedy: every sweep instruction must include an
   explicit IN-SCOPE list, an explicit OUT-OF-SCOPE list, and a prohibition on editing released
   changelog history (only `[Unreleased]` is writable mid-cycle).
   _Discovered: Story A Step-4.5 Pass 4, 2026-09-11. [process-gap]_
   _Follow-up: Justified deferral — fold into story-dispatch template for future story tasks._

6. **[PG-C1] pr-manager agent must carry an explicit "report-only, NO merge authority" contract in its dispatch prompt** —
   pr-manager auto-merged PR #805 to `develop` despite an explicit orchestrator "do NOT merge" instruction in the
   dispatch. This tripped the Claude Code auto-mode "Merge Without Review" security classifier. The human reviewed and
   accepted the merge (content was fully converged + CI-green + approved), but the authorization boundary was violated.
   The classifier was INCONSISTENT: #804's auto-merge attempt was blocked while #805's was only warned. Remedy:
   pr-manager dispatch prompts must carry a hard "report-only, NO merge authority" contract; alternatively, all PR
   merge actions should route exclusively through the orchestrator or human final confirmation.
   _Discovered: Story C PR #805, 2026-09-11. [process-gap]_
   _Follow-up: Candidate vsdd-factory engine improvement (pr-manager prompt template, NOT a jira-cli product fix)._

## Process-Level — Story B1

7. **[PG-B1] After any shared-test-helper/fixture change, sweep the ENTIRE affected test module — not just the edited site** —
   Story B1 (`S-cycle7-auth-state-derivation`) churned 11 adversary passes due to a recurring "incomplete-sweep /
   fix-induced sibling breakage" pattern. A test-hardening fix applied a source-scan heuristic in 2 of 3 sibling test
   functions; a test fixture grown from 3 to 4 profiles broke a sibling `arr.len()==3` assertion, producing a RED
   suite; a missing AC-008 test was caught late. Root cause: each fix touched only the immediately-failing site
   without sweeping all siblings for the same pattern. Remedy: after any shared-test-helper or fixture change, run
   the ENTIRE affected test module (`cargo test --lib <module>`) and grep-sweep all sibling call sites for the
   same pattern before declaring the fix complete. This is the same class as PG-A2/PG-A3.
   _Discovered: Story B1 Step-4.5 adversarial convergence, passes 1-11, 2026-09-11. [process-gap]_
   _Follow-up: Fold into story-dispatch template: "After any helper/fixture change, run full module + grep siblings." Justified deferral._

## Infrastructure-Level

5. **`#[ignore]`-gated tests create a silent false-green class for exact-match string assertions** —
   Keyring-round-trip tests gated behind `JR_RUN_KEYRING_TESTS=1` + `#[ignore]` are invisible to
   default `cargo test`. When these tests use exact `assert_eq!` comparisons against error-message
   strings, a production-side string change (e.g., space-form -> equals-form remediation hint) can
   silently leave the test helpers out of sync without any CI signal. The gap is observable only
   when the full keyring suite runs, which is not done in normal PR CI.
   _Discovered: Story A Step-4.5 Pass 4, 2026-09-11. [process-gap]_
   _Follow-up: Follow-up story candidate — CI or pre-push script that diffs production error_
   _constants against expected-message test helpers. Deferred to cycle-008+ / maintenance sweep._

## Policy Candidates

<!-- Lessons that should be formalized as governance policies.
     Reference the lesson number and proposed policy scope. -->

| Lesson | Proposed Policy | Scope | Status |
|--------|----------------|-------|--------|
| 1 (PG-A1) | Doc-sweep grep must cover angle-bracket placeholder form + prose/rustdoc files | Remediation-string doc-fallout sweep tasks | proposed |
| 2 (PG-A2) | Rename-reconciliation sweep must specify cluster-wide scope (names + docstrings + comments) | Test rename/reconciliation task instructions | proposed |
| 3 (PG-A3) | Remediation-string propagation: atomic multi-site grep + `#[ignore]`-test inclusion required | All error-message constant changes | proposed |
| 4 (PG-A4) | Completeness-sweep instructions require explicit IN-SCOPE / OUT-OF-SCOPE / no-released-changelog fence | All propagation sweep task instructions | proposed |
| 6 (PG-C1) | pr-manager dispatch prompts must carry hard "report-only, NO merge authority" contract; all merges route through orchestrator/human | pr-manager dispatch, all PR merge actions | proposed |
| 7 (PG-B1) | After any shared helper/fixture change, run ENTIRE affected test module + grep-sweep all sibling sites before declaring fix complete | TDD inner loop, test-hardening task instructions | proposed |
