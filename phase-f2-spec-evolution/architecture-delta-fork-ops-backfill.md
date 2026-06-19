---
document_type: f2-architecture-delta
phase: phase-f2-spec-evolution
feature: fork-ops-backfill-parity
bundle: S-FORK-OPS-BACKFILL
created: 2026-06-18
status: complete
traces_to:
  - ".factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md"
---

# F2 Architecture Delta — S-FORK-OPS-BACKFILL (Fork-Ops Backfill Parity)

## Finding: No Structural Architecture Change

This bundle requires **no changes to any architecture artifact** in
`.factory/architecture/` or `.factory/specs/`.

## Rationale

The three drift items (WIN-TARGET, DESTRUCTIVE, GITLEAKS-DOC) are confined to:

1. `.github/workflows/backfill-release.yml` — CI/CD workflow YAML only. No new
   module, no new interface, no change to the `jr` binary's behavior, no new
   dependency introduced into `Cargo.toml` or `Cargo.lock`.
2. `docs/specs/fork-friendly-release-ops.md` — documentation of an existing CI
   mechanism (`vars.GITLEAKS_DISABLED`) that already exists in `ci.yml` line 145.
3. `CLAUDE.md` — AI-agent documentation note.

The `jr` binary's public API surface (CLI flags, JSON output shapes, exit codes),
its internal module decomposition, its crate dependency graph, its authentication
flow, its cache layout, and its Jira/JSM/Assets API integration are all entirely
unchanged.

## Architecture Documents Unaffected

| Document | Status |
|----------|--------|
| `.factory/architecture/system-overview.md` | UNCHANGED |
| `.factory/architecture/component-graph.md` | UNCHANGED |
| `.factory/architecture/cross-cutting.md` | UNCHANGED |
| `.factory/architecture/risk-register.md` | UNCHANGED |
| `.factory/architecture/adr/` (all ADRs) | UNCHANGED |
| `.factory/architecture/adr-index.md` | UNCHANGED |

## Scope Boundary

The change is confined to the CI/CD release pipeline — the infrastructure that
packages and publishes the binary, not the binary itself. No architecture review
or ADR is warranted for:

- Adding a Windows matrix entry to an existing build job (replicates the pattern
  already documented and implemented by S-WIN-4 / ADR-0016).
- Replacing a destructive release-create pattern with an idempotent check-then-upsert
  (operational correctness improvement, not an architectural decision).
- Documenting an existing CI gate variable (`GITLEAKS_DISABLED`) that was
  already operative in `ci.yml`.

ADR-0016 (Windows build target) remains the authoritative architecture record for
the `x86_64-pc-windows-msvc` target decision. `backfill-release.yml` adding this
target to its matrix is an implementation-of-the-ADR action, not a new decision.

## Conclusion

F4 implementers should proceed directly from `spec-delta-fork-ops-backfill.md`
without any architecture pre-work. The regression baseline (all architecture
documents unchanged) is the correct state entering F4.
