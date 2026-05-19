# S-288-pr2-cli Adversary Pass 08

## Verdict
ADVISORY-CLEAN — adversary explicit verdict was "CLEAN with one process-gap observation." One MEDIUM-class CLAUDE.md doc drift (M-1) flagged as follow-up; orchestrator opts to fix inline before claiming 1/3 to avoid leaving any open finding before the convergence counter advances.

## Findings

### CRITICAL / HIGH
None.

### MEDIUM (orchestrator-resolved inline)

**M-1 [process-gap]: CLAUDE.md (worktree) misdescribes `call_site_label` values**
- File: `CLAUDE.md:223-227` worktree copy
- Claims callers pass `"queue commands"` and `"jr requesttype"` (the pre-pass-03 strings).
- Actual literals (per source-of-truth rustdoc + impl):
  - `src/cli/queue.rs:32` → `"Queue commands (\`jr queue\`) require"`
  - `src/cli/requesttype.rs:38` → `` "`jr requesttype` commands require" ``
- Rustdoc in `src/api/jsm/servicedesks.rs:104-107` is canonical and correct; CLAUDE.md gotcha is stale stub.
- Risk: AI agents grep CLAUDE.md first; copying the stale stubs would produce ungrammatical user-facing errors.
- **Fix**: orchestrator updates CLAUDE.md inline to quote actual literals.

### LOW / NIT
- **L-1**: BC-X.12.005 vs BC-X.12.007 first-column wording ("Field Name" vs "Field") — spec self-consistency drift; impl matches X.12.005 (primary BC); defer.
- **L-2**: `--search ""` empty-string normalization not test-pinned (mutation-test gap, no runtime defect).
- **L-3**: BC-X.12.004 element shape allows `description: "<str>"` but impl emits `null` when missing; BC wording loose. Defer.
- **L-4**: Empty-list rendering emits `"No results found."` instead of literal empty table per BC-X.12.002. Functionally satisfies "exits 0 NOT an error"; spec is loose. Defer.

### Observations (positive)
- All AC-001..AC-012 → named test mappings strict (verbatim BC pins, exit codes, negative-space guards)
- Cross-profile cache isolation directly unit-tested for both new families (POLICY multi-profile-cache CRITICAL satisfied)
- Best-effort writer pattern documented in CLAUDE.md + rustdoc
- JSON output handler-side shape correctly remaps `requestTypeFields` → `fields` per BC-X.12.007 with negative-space pin against raw-API key leak
- ExactMultiple case-variant + numeric-bypass + corrupt-cache self-heal + cache-write-best-effort all individually pinned

### Process-gap findings
- **PG-1**: Second occurrence of CLAUDE.md gotcha being stale relative to actual impl literal. Could be caught by a `scripts/check-claudemd-callsite-labels.sh` script. File as follow-up.

## Reviewed surfaces / Not reviewed
- (Per adversary's report — full read of src/, tests/, spec, CLAUDE.md, story)

## Triage / routing

| Finding | Action |
|---------|--------|
| M-1 | orchestrator inline fix (CLAUDE.md) |
| L-1..L-4 | DEFER |
| PG-1 | follow-up issue post-merge |

Next: orchestrator fixes M-1, then re-runs adversary pass 09 to confirm CLEAN. If pass 09 is CLEAN with no MEDIUM+ findings, counter advances to 1/3.

Novelty: **LOW** — only one substantive finding (CLAUDE.md doc drift); impl + tests + spec have genuinely converged.
