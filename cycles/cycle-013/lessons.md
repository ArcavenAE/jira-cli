---
document_type: lessons
level: ops
version: "1.0"
status: active
producer: state-manager
timestamp: 2026-09-16T21:42:00Z
cycle: "cycle-013-msrv-1.88-bump"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-013-msrv-1.88-bump

<!-- Lessons are codified as [codified] when formally recorded and adopted as process policy.
     Lessons are [draft] until reviewed and accepted by the orchestrator/human gate.
     Add newest lessons at the top, maintaining reverse-chronological order. -->

## L-001 — `saphyr` Low-Level-Parser-Only Convention Is a Load-Bearing Security Constraint, Not Style (F5 scoped adversarial, security-reviewer, 2026-09-16) [codified]

**Category:** Infrastructure-level / dependency-usage convention

**Lesson:** The repo's existing convention of using `saphyr-parser`'s low-level
`Parser`/`Event` stream in `tests/common/wf.rs` — never the higher-level
`saphyr::Yaml`/`YamlLoader` API — has so far been documented (in CLAUDE.md's CI-gate
section) purely as an implementation-mechanics note about how `ci.yml` gets structurally
parsed for the CI-gate completeness guard. The F5 security-reviewer pass for cycle-013
(triggered by the MSRV bump additionally pulling `saphyr-parser` into the widened
`--all-targets` msrv-job compile scope) surfaced that this is not merely a style choice:
there is an open upstream billion-laughs/DoS advisory (saphyr-rs/saphyr#109) that affects
only the high-level `YamlLoader` API, not the low-level `Parser`/`Event` stream this repo
actually uses. The convention of never adopting `YamlLoader` is therefore load-bearing —
switching to it (e.g., for developer convenience in a future CI-gate guard rewrite) would
reintroduce a real, currently-inapplicable DoS exposure, even though the crate is a
`[dev-dependencies]`-only entry with no production/release-binary exposure.

**Policy:** Treat "never use saphyr's `YamlLoader` — low-level `Parser`/`Event` stream
only" as a security constraint on any future `tests/common/wf.rs` change or any new
YAML-parsing code added to this repo's CI-gate or spec-guard tooling, not just an existing
style preference. Any PR touching `tests/common/wf.rs`'s parsing approach, or introducing
a new `saphyr`/YAML-parsing dependency elsewhere in the repo, should be security-reviewed
against this constraint explicitly, and CLAUDE.md's CI-gate section should be read as
carrying this security rationale alongside its existing mechanics rationale.

**Evidence:** `cycles/cycle-013/phase-f5-adversarial/security-review.md` (basis item 2):
confirmed via inspection of `tests/common/wf.rs`'s imports that only `Parser`/`Event` are
used, never `saphyr::Yaml`/`YamlLoader`; cross-referenced against the open upstream issue
saphyr-rs/saphyr#109, which is scoped to the high-level API.

**Closes:** (informational — no open issue; recorded for F7 lessons review)
