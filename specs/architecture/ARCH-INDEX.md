# Architecture Index — jr (jira-cli)

> **Canonical ADR location (ADR-0017+):** `.factory/specs/architecture/decisions/` (this directory).
> ADRs 0001–0016 predate the VSDD-factory migration and live in `docs/adr/`; their index is at
> `.factory/architecture/adr-index.md`. Do NOT create ADR-0017+ under `docs/adr/`.
>
> **Artifact-path-registry reference:** `artifact-path-registry.yaml` — `adr` artifact type.

---

## Subsystem Registry

| SS-ID | Name | Primary Source Files |
|-------|------|---------------------|
| SS-01 | Entry Point & Runtime | `src/main.rs` |
| SS-02 | CLI Layer | `src/cli/` |
| SS-03 | HTTP Client Core | `src/api/client.rs`, `src/api/auth.rs`, `src/api/auth_embedded.rs`, `src/api/auth_windows_store.rs`, `src/api/pagination.rs`, `src/api/rate_limit.rs`, `src/api/refresh_coordinator.rs` |
| SS-04 | Jira API Resources | `src/api/jira/` |
| SS-05 | JSM API Resources | `src/api/jsm/` |
| SS-06 | Assets API Resources | `src/api/assets/` |
| SS-07 | Type Layer | `src/types/` |
| SS-08 | Cross-cutting Utilities | `src/adf.rs`, `src/cache.rs`, `src/config.rs`, `src/output.rs`, `src/error.rs`, `src/jql.rs`, `src/duration.rs`, `src/partial_match.rs`, `src/observability.rs` |
| SS-09 | Build & Release | `Cargo.toml`, `build.rs`, `.github/workflows/`, `deny.toml` |

---

## Architecture Decisions

> New ADRs use `decisions/ADR-NNNN-<slug>.md` under this directory. Subsystem column references the
> SS-IDs from the Subsystem Registry above.

| ADR | Title | Subsystems | File |
|-----|-------|------------|------|
| ADR-0017 | First multipart/streaming HTTP surface: reqwest multipart+stream features + tokio-util direct dependency | SS-03, SS-09 | decisions/ADR-0017-first-multipart-streaming-http-surface.md |
| ADR-0018 | Component resolution, caching, delete-safety, and mutation-wire-shape strategy | SS-02, SS-04, SS-07, SS-08 | decisions/ADR-0018-component-resolution-caching-mutation-strategy.md |
| ADR-0019 | Field DX: option-enumeration context strategy, hint-kind value-spec shape, and cascading-select delimiter | SS-02, SS-04, SS-05 | decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md |
| ADR-0020 | Per-Profile Credential Ownership, Environment Tagging, and OAuth-Default-at-Creation | SS-02, SS-03, SS-08 | decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md |
| ADR-0021 | Windows OAuth Secret Storage — Keyring-First with DPAPI-Encrypted-File Fallback | SS-03, SS-08, SS-09 | decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md |
| ADR-0022 | API-Token Cloud ID Acquisition via `/_edge/tenant_info`, and the A-PA-LOW-001 Guard | SS-02, SS-03, SS-04, SS-08 | decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md |
