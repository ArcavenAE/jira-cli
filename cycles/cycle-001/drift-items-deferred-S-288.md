---
document_type: drift-items-archive
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-05-26T00:00:00
cycle: "cycle-001"
inputs: [STATE.md]
traces_to: STATE.md
---

# Deferred Drift Items — S-288-pr2-PG Group

<!-- 13 DEFERRED process-gap items from the S-288-pr2 cycle, archived from STATE.md
     during compact-state run (2026-05-26) to keep STATE.md under 200 lines.
     Status remains DEFERRED — these are NOT resolved.
     The condensed index row in STATE.md "Drift Items" table points here.
     S-288-pr2-PG-2c is NOT here — it was RESOLVED inline and archived to
     cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| S-288-pr2-PG-1a | [process-gap] Tautological BC-string assertions: tests assert the same string literal used in the BC body — no semantic daylight between test and contract. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-2a | [process-gap] Dangling `Pinned by:` references in BC bodies with no resolvable test name anchor — no automated checker script exists. Target: `scripts/check-ac-pins.sh`. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-3a | [process-gap] Free-form `call_site_label` string allows arbitrary drift between callers — no typed enum enforces canonical phrases. Target: typed enum refactor for call_site_label. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-1b | [process-gap] L-288-pr1-01 (no `||`/`.or_else()` in positive assertions) is not enforced at gate — no PR template question or grep-lint. Target: grep-lint in ci.yml or PR template checkbox. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-2b | [process-gap] Shared error-hint suffix convention (e.g., "run jr ... to inspect") is not codified as a CLAUDE.md convention — each handler invents its own wording. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-3b | [process-gap] Verbatim BC-string ≥2/3 rule not codified in test-writer prompt — tests can paraphrase BC-mandated strings instead of pinning them verbatim. Target: codify in test-writer prompt. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-1c | [process-gap] BC-mandated string updates don't automatically propagate to all callers — sentence-level pin rule not enforced. When a BC body changes a required error string, all test pins for that string must update in the same commit. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-F1 | [process-gap] No `[lints.clippy]` deny-list pinning in Cargo.toml — clippy lints enabled only via CLI flag; no permanent project-level deny config. Target: Cargo.toml `[lints.clippy]` section. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-1e | [process-gap] No CI lint for single-component use imports — `use crate::foo::bar` (single item) vs `use crate::foo::{bar}` style inconsistency unchecked. Target: codify import style in clippy or rustfmt config. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-1f | [process-gap] "No accept-either" assertion rule (no `||` in positive assertions) has no automated grep-lint — L-288-pr1-01 recurred 4× despite being codified. Target: grep `tests/` for `\|\|` and `.or_else(` in new test code on every adversary pass; report as MEDIUM. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
| S-288-pr2-PG-1g | [process-gap] CLAUDE.md `call_site_label` canonical-phrases list can drift from actual production callers — no `scripts/check-claudemd-callsite-labels.sh` checker exists. Target: create checker script. | LOW | DEFER → post-S-288 self-improvement epic. Not a content defect; process-gap codification. Per S-7.02 cycle-closing-checklist. |
