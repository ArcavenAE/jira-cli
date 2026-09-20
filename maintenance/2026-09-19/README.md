# Maintenance Sweep — 2026-09-19

**Status: ANALYSIS COMPLETE, FIX DELIVERY PENDING.**

These four files are the analysis outputs of the 2026-09-19 maintenance sweep,
run against `develop @ 3d9ca35e` (post cycle-008 `oauth-surface-correctness`
close). All four are **read-only audits** — no `src/`, `.factory/`, or
`deny.toml` files were modified, and no commits were made, during the sweep
itself. They were preserved here on 2026-09-20 (SESSION-WRAP-PAUSE) from
session-scoped scratchpad storage so the findings survive a `/clear`.

## Files

| File | Scope | Headline |
|------|-------|----------|
| `01-dependency-audit.md` | `cargo deny` / `cargo audit` against `develop @ 3d9ca35e` | Healthy baseline (0 vulnerabilities / 360 crates); 2 stale `deny.toml` skip entries (`windows_i686_gnullvm`, `cpufeatures`) are automated-fixable housekeeping; `syn` 2/3 skip is still genuinely needed, do NOT remove |
| `02-doc-drift.md` | `CLAUDE.md`, `docs/specs/`, `docs/adr/`, `.factory/specs/architecture/decisions/`, `README.md` | Cycle-008/ADR-0026 doc fallout: HIGH finding — ADR-0026's OAuth gateway-routing invariant (`base_url()` not `instance_url()` under OAuth) is undocumented in CLAUDE.md Gotchas; plus stale LOC figures and a stale `saphyr-parser` pin reference |
| `03-pattern-consistency.md` | `src/` legacy-vs-new pattern scan | Mostly clean; one LOW automated-fixable call-site inconsistency (`src/cli/requesttype.rs` cache-writer `?` should be `let _ =`, model-b writer convention); one pre-existing tracked deferral noted for completeness (ADR-0026 Workstream D) |
| `05-consistency-cluster.md` | Spec coherence (Sweep 7) + related consistency checks (Sweeps 8/11) | All automated guard scripts PASS; `STORY-INDEX.md` stale `file_path` fix pending aggregation |

## Pending fix-delivery work (as of 2026-09-20 wrap)

The sweep's **3 fix PRs are NOT yet created**:

1. **CLAUDE.md doc-fix** — undocumented ADR-0026 OAuth gateway-routing invariant
   (`base_url()` not `instance_url()` under OAuth), `classify_401_body` +
   Agile scope-hint docs, stale `cli/auth/tests/mod.rs` LOC figure,
   `saphyr-parser` pin reference `=0.0.11` → `=0.0.12`, historical marker on
   `docs/specs/oauth-scopes-configurable.md`.
2. **`deny.toml` housekeeping** — drop 3 unused license allowances + the
   now-stale `cpufeatures` & `windows_i686_gnullvm` skips; keep `syn` 2/3.
3. **Cache-writer call-site fix** — `src/cli/requesttype.rs` `?` → `let _ =`.

Additionally pending: sweep report aggregation, and the `STORY-INDEX.md`
stale `file_path` fix (S-3.03/S-3.07).

Dependabot #842 (base64 0.23) is HELD OPEN (multiple-versions ban; awaiting
`hyper-util`).

See `.factory/STATE.md`'s Session Resume Checkpoint (2026-09-20) for the
authoritative pending-work record.
