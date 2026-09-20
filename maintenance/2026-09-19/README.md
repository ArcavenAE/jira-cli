# Maintenance Sweep — 2026-09-19

**Status: FIX DELIVERY COMPLETE (2026-09-20).**

These four files are the analysis outputs of the 2026-09-19 maintenance sweep,
run against `develop @ 3d9ca35e` (post cycle-008 `oauth-surface-correctness`
close). All four are **read-only audits** — no `src/`, `.factory/`, or
`deny.toml` files were modified, and no commits were made, during the sweep
itself. They were preserved here on 2026-09-20 (SESSION-WRAP-PAUSE) from
session-scoped scratchpad storage so the findings survive a `/clear`.

**Fix delivery (2026-09-20):** all 3 fix PRs identified below were delivered
and merged to `develop`, each via the standard flow (isolated worktree →
implement → clean local review [`code-reviewer` CLEAN] → PR → fresh-eyes
`pr-reviewer` [APPROVE, posted as a COMMENTED review — self-approval is
structurally blocked on a self-authored PR] → CI Gate SUCCESS → human
admin-merge → worktree cleaned up):

| PR | Title | Merge SHA |
|----|-------|-----------|
| `#848` | `docs(maint-20260919-01)`: ADR-0026 OAuth gateway-routing invariant + `classify_401_body`/`rewrite_agile_scope_error` 401-scope-reclassification doc bullets, expired-token-401 addendum, `oauth-scopes-configurable.md` historical marker, `cli/auth/tests/mod.rs` LOC 2484→2570, `saphyr-parser` pin ref `=0.0.11`→`=0.0.12` | `7a57ed53` |
| `#849` | `chore(maint-20260919-02)`: `deny.toml` housekeeping — removed 3 stale license allowances (`BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016`) + `windows_i686_gnullvm` `^0.53` and `cpufeatures` `^0.2` skips; `syn` 2/3 skips retained; `cargo deny check` clean | `d85a8136` |
| `#850` | `chore(maint-20260919-03)`: `src/cli/requesttype.rs` cache-writer call-site consistency — 3 call sites `?`→`let _ =` (model-b let-discard convention, matching `jsm_create.rs`); zero behavior change | `7e0f9cbd` |

Still pending (not part of this fix-delivery batch): sweep report aggregation,
and the `STORY-INDEX.md` stale `file_path` fix (S-3.03/S-3.07). Process-gap
findings observed during this delivery are logged in
`cycles/OPEN-STANDING-ITEMS.md` under "Maintenance sweep 2026-09-19 (fix
delivery, closed 2026-09-20) — process-gap findings".

## Files

| File | Scope | Headline |
|------|-------|----------|
| `01-dependency-audit.md` | `cargo deny` / `cargo audit` against `develop @ 3d9ca35e` | Healthy baseline (0 vulnerabilities / 360 crates); 2 stale `deny.toml` skip entries (`windows_i686_gnullvm`, `cpufeatures`) are automated-fixable housekeeping; `syn` 2/3 skip is still genuinely needed, do NOT remove |
| `02-doc-drift.md` | `CLAUDE.md`, `docs/specs/`, `docs/adr/`, `.factory/specs/architecture/decisions/`, `README.md` | Cycle-008/ADR-0026 doc fallout: HIGH finding — ADR-0026's OAuth gateway-routing invariant (`base_url()` not `instance_url()` under OAuth) is undocumented in CLAUDE.md Gotchas; plus stale LOC figures and a stale `saphyr-parser` pin reference |
| `03-pattern-consistency.md` | `src/` legacy-vs-new pattern scan | Mostly clean; one LOW automated-fixable call-site inconsistency (`src/cli/requesttype.rs` cache-writer `?` should be `let _ =`, model-b writer convention); one pre-existing tracked deferral noted for completeness (ADR-0026 Workstream D) |
| `05-consistency-cluster.md` | Spec coherence (Sweep 7) + related consistency checks (Sweeps 8/11) | All automated guard scripts PASS; `STORY-INDEX.md` stale `file_path` fix pending aggregation |

## Fix-delivery work — COMPLETE (2026-09-20)

The sweep's 3 fix PRs (listed in the table above) are **merged to `develop`**:

1. **CLAUDE.md doc-fix** (`#848` @ `7a57ed53`) — undocumented ADR-0026 OAuth
   gateway-routing invariant (`base_url()` not `instance_url()` under OAuth),
   `classify_401_body` + Agile scope-hint docs, stale
   `cli/auth/tests/mod.rs` LOC figure, `saphyr-parser` pin reference
   `=0.0.11` → `=0.0.12`, historical marker on
   `docs/specs/oauth-scopes-configurable.md`.
2. **`deny.toml` housekeeping** (`#849` @ `d85a8136`) — drop 3 unused license
   allowances + the now-stale `cpufeatures` & `windows_i686_gnullvm` skips;
   keep `syn` 2/3.
3. **Cache-writer call-site fix** (`#850` @ `7e0f9cbd`) —
   `src/cli/requesttype.rs` `?` → `let _ =`.

Still pending (not part of this fix-delivery batch): sweep report
aggregation, and the `STORY-INDEX.md` stale `file_path` fix (S-3.03/S-3.07).

Dependabot #842 (base64 0.23) is HELD OPEN (multiple-versions ban; awaiting
`hyper-util`).

See `.factory/STATE.md`'s Session Resume Checkpoint (2026-09-20) for the
authoritative pending-work record.
