---
story: S-FORK-OPS-SIGN-1
phase: F1-delta-analysis
date: 2026-06-18
status: COMPLETE
---

# F1 Delta Analysis — S-FORK-OPS-SIGN-1 (fork-ops signing workflow hardening)

## Summary

Targeted security hardening of the fork-ops signing and publishing CI workflows.
Two HIGH security drift items identified during arcaven PR review (#528/#529/#530)
require remediation before signing can be enabled.

## Trigger

Drift items FORK-OPS-SIGN-INJECTION and FORK-OPS-ALPHA-RACE from the arcaven PR
review on 2026-06-18 (three LOW nits also in scope: FORK-OPS-NIT-USECROSS-GUARD,
FORK-OPS-NIT-TMP-PREDICTABLE, FORK-OPS-NIT-PIPEFAIL).

## Affected Files

See `affected-files.txt`.

## Security Findings (input)

| ID | Severity | Description |
|----|----------|-------------|
| FORK-OPS-SIGN-INJECTION | HIGH | github.event.workflow_run.head_branch unquoted in shell + all inline attacker-controllable context; CWE-77. Affects sign-and-publish.yml. |
| FORK-OPS-ALPHA-RACE | HIGH | Non-atomic alpha tag creation — TOCTOU race. |
| FORK-OPS-NIT-USECROSS-GUARD | LOW | rustup target add step lacks use_cross guard. Already satisfied by PR #529. |
| FORK-OPS-NIT-TMP-PREDICTABLE | LOW | /tmp/cs.out + /tmp/spctl.out predictable paths → switch to mktemp+trap (CWE-377/362). |
| FORK-OPS-NIT-PIPEFAIL | LOW | set -e without set -o pipefail on codesign | tee chains (CWE-390). |

## Scope Decision

CI-workflow-only change (`.github/workflows/sign-and-publish.yml`). No product
source changes. No BC changes. Story scope: security hardening + new injection
guard script (`scripts/check-signing-workflow-injection.sh`) wired into ci-gate.

## Deliverable Summary

- Sign-and-publish.yml hardened: env-binding all attacker-controllable context,
  atomic alpha-tag via `gh api git/refs`, mktemp+trap for temp files, pipefail.
- `scripts/check-signing-workflow-injection.sh` — YAML-structure-aware injection
  guard, structural scope (every secrets/contents:write job), default-deny,
  fail-closed, positive-coverage assertion + negative self-test fixture.
- ci.yml: ci-gate.needs extended (6→7 jobs).
- tests/ci_gate_completeness.rs: updated for 7 ci-gate jobs.

_Recorded: 2026-06-18_
