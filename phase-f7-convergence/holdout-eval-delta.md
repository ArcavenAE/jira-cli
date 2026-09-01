# Holdout Evaluation — Phase F7 Dimension-5 (field-dx delta)

Binary: target/debug/jr @ develop dd311e13 (built clean, 47s). Info-asymmetry: source/specs/reviews not read; scenarios + public CLI surface only.

## Per-Scenario Results

| Scenario | must_pass | Score | Basis |
|----------|-----------|-------|-------|
| H-NEW-PREFLIGHT-001 | y | 0.85 | `--field` alone no longer exits 64/"only valid with"; proceeds to HTTP (createmeta path). Exit-0 + POST-body merge backend-dependent. |
| H-NEW-PREFLIGHT-002 | y | 1.00 | `--on-behalf-of` alone → exit 64, VERBATIM error, zero HTTP; JSON envelope `{code:64}`. Fully observed. |
| H-NEW-PREFLIGHT-003 | y | 1.00 | both flags → standalone on-behalf-of guard fires (exit 64); combined + field-alone strings ABSENT; zero HTTP. Fully observed. |
| H-NEW-PREFLIGHT-004 | y | 0.90 | neither flag → no guard string; proceeds to HTTP. Exit-0/"Created issue" backend-dependent; decisive no-mis-fire signal confirmed. |
| H-NEW-PREFLIGHT-005 | y | 0.90 | `--field`+`--on-behalf-of`+`--request-type` → guards do NOT fire; routes to JSM path (HTTP attempted). Exit-0/HELP-1 backend-dependent. |
| H-NEW-PREFLIGHT-006 | y | 0.85 | `--field` alone `--output json` → no dead guard; HTTP attempted (envelope code 1 network, not code 64). Exit-0 `"key"` backend-dependent. |
| H-NEW-EDIT-FIELD-001 | y | 0.75 | single-key `--field` reaches HTTP (not multi-key guard). Editmeta-gate error string + zero-PUT backend-dependent. |
| H-NEW-EDIT-FIELD-002 | y | 1.00 | multi-key `--field` → exit 64 "Multi-key bulk edit doesn't yet support: --field"; zero HTTP. Fully observed. |
| H-NEW-JSM-RT-007 | y | 1.00 | `--markdown --field description=` → exit 64; all 3 canonical substrings present; zero HTTP. Fully observed. |

## Supplementary (no numbered holdout; surface + parser only)
- `jr field options` present with M1/M2/M3 (`--issue`/`--type`/`--request-type`), `--value`, `--output`, ADR-0019 help. Mode-selector validation → exit 64.
- Hint kinds: malformed `:kind` ("foo:boguskind=val") → exit 64 listing valid kinds "option, id, name, asset"; empty kind ("foo:=val") → exit 64. Valid kind proceeds to HTTP.
- `--field` help text: "resolves against the project's Create screen (createmeta)" — no "requires --request-type" wording (old DEC-188 dead string absent).

## Summary
- Evaluated: 9 field-dx delta scenarios (all must_pass).
- Mean satisfaction: 0.917.
- Minimum must-pass: 0.75 (H-NEW-EDIT-FIELD-001) ≥ 0.60.
- Backend-dependent (could not fully verify under info-asymmetry — success POST/exit-0 paths): PREFLIGHT-001, 004, 005, 006, EDIT-FIELD-001. All confirmed the DECISIVE observable (guard removal / correct routing / no mis-fire); only the live-Jira success side is unverified. Scores NOT inflated to 1.0.

## VERDICT: PASS (mean 0.917 ≥ 0.85 AND all must-pass ≥ 0.60)
