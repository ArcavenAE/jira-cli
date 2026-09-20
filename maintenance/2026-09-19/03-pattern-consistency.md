# Pattern-Consistency Audit — 2026-09-19 (maintenance sweep)

Read-only scan of `src/` for legacy-vs-new pattern drift. No files modified.

## Summary

**Mostly clean.** One LOW, automated-fixable call-site inconsistency found (item 1).
Everything else checked out consistent with documented conventions. One item (3) is
a pre-existing, already-tracked deferral (ADR-0026 Workstream D) — noted for
completeness, not a new finding.

---

## Findings

### 1. [LOW / automated-fixable] Inconsistent call-site discard style for the two model-b request-type cache writers

`write_request_type_cache` and `write_request_type_fields_cache` (`src/cache.rs`,
~L584-L691) are both model-b writers per the documented convention: they swallow
their internal I/O error with `eprintln!("warning: ...")` and unconditionally
`return Ok(())`. Call sites therefore should treat the `Result` as infallible.

- `src/cli/requesttype.rs:89`, `:130-133`, `:201` — use `?` on the call.
- `src/cli/issue/jsm_create.rs:747`, `:776` — use `let _ = ...` on the call
  (with an inline comment: `// write_request_type_cache is a best-effort writer
  per CLAUDE.md gotcha`), which is the style CLAUDE.md prescribes for
  `write_cmdb_fields_cache`/`write_object_type_attr_cache`.

Not a correctness bug (the fn body never actually returns `Err`), but it's the
same two writer functions used two different ways in the same codebase, and it
invites a future reader in `requesttype.rs` to think a `?` failure path is
reachable there when it isn't. Batch-fixable: change the three `requesttype.rs`
call sites from `?`/propagate style to `let _ = cache::write_request_type...`
(or add the same explanatory comment jsm_create.rs already carries), matching
the CLAUDE.md-documented call-site convention for model-b writers.

- Category: pattern-consistency
- Severity: LOW
- Fix effort: mechanical, ~3 call sites, no behavior change

---

## Areas checked, no drift found

1. **`#[allow(...)]` suppressions in `src/`:** only 2 real ones exist —
   `src/adf.rs:10099` (`#[allow(clippy::too_many_lines)]`, test-only, justified
   inline, matches CLAUDE.md's documented ADR-0012 exception for `adf.rs`) and
   `src/api/refresh_coordinator.rs:56` (`#[allow(dead_code)]`, gated
   `#[cfg(test)]`, doc-justified as a test-only reset helper). No new/undocumented
   suppressions introduced.

2. **JSON output invariant (#526):** no direct `serde_json::to_string_pretty` or
   compact `json!` `Display`-printing bypassing `output::render_json`/
   `output::print_output` anywhere in `src/cli/`. Every `json!(...)` construction
   in `src/cli/` is either (a) an HTTP request-body payload, (b) a builder
   function whose return value is later passed through `render_json` (e.g.
   `refresh_success_payload`, `auth_json_response`, `render_list_json`,
   `sprint_add_response`), or (c) test fixture data. `src/cache.rs`'s
   `serde_json::to_string_pretty` calls are internal cache-file serialization,
   out of #526's scope (that invariant governs `--output json` CLI rendering,
   not on-disk cache format).

3. **Profile-scoping boundary:** every cache reader/writer in `src/cache.rs`
   takes `profile: &Profile` (the ADR-0011 type-fence, stricter than the
   `profile: &str` CLAUDE.md describes — the newtype landed after that
   paragraph was written) as its **first** parameter, with no exceptions.
   Checked all 26 `pub fn` cache accessors. No cross-profile leakage risk found.

4. **Cache-write error-handling models (model-a propagate vs model-b
   swallow+warn):** consistent given context. `write_team_cache` is model-a
   (propagates); its two call sites apply it correctly — `team.rs::handle_list`
   uses `?` (a `jr team list` cache-write failure should surface), while
   `init.rs`'s prefetch step downgrades the same call to `if let Err(err) = ...
   { eprintln!("warning: ...") }` because it's a best-effort warm-cache step
   during setup, not the primary operation — that's a deliberate, appropriate
   context-specific choice, not model confusion. `write_cmdb_fields_cache` /
   `write_object_type_attr_cache` call sites correctly use `.ok()` exactly as
   CLAUDE.md mandates. (Item 1 above is the one place this call-site discipline
   drifted.)

5. **Cycle-008 code specifically** (`src/api/client.rs::classify_401_body`,
   `src/cli/board.rs`, `sprint.rs`, `issue/list.rs`, `api/jsm/queues.rs`,
   `api/assets/workspace.rs`, `cli/init.rs`):
   - `classify_401_body` is a small, pure, well-isolated helper with inline
     unit tests co-located per module (`#[cfg(test)] mod classify_401_body_tests`)
     — matches the file's existing test-organization convention.
   - `rewrite_agile_scope_error` / `is_insufficient_scope_error` (the F5
     chain-aware downcast fix, commit `fc608cd3`) is now consistently the only
     mechanism for Agile-scope-error classification, called uniformly from
     `board.rs`, `sprint.rs`, `init.rs`, and `issue/list.rs` (2 sites) with the
     same `(err, client, hint)` signature. No leftover single-level
     `downcast_ref::<JrError>()` bypass of the chain-aware helper for this
     specific error class — the handful of other raw `downcast_ref::<JrError>()`
     sites elsewhere in the tree are unrelated error classifications (404
     handling, UserError classification, etc.), not duplicated/competing scope
     logic.
   - The OAuth-gateway-routing fixes (`get_from_instance`→`get`,
     `post_from_instance`→`post`) landed in `api/jsm/queues.rs`,
     `api/jsm/request_types.rs`, `api/jsm/requests.rs`,
     `api/jsm/servicedesks.rs`, `api/assets/workspace.rs` per ADR-0026. Grepping
     `src/api/` + `src/cli/` for remaining `from_instance` call sites turns up
     exactly one: `src/api/jira/teams.rs:43` (`get_from_instance` in
     `list_teams`). This is **not** undiscovered drift — ADR-0026 §4
     explicitly defers "Teams" (Workstream D) out of cycle-008 scope as a
     documented, known-broken-under-OAuth residual (`jr team list` remains
     broken under OAuth exactly as before), pending a possible third
     host-family design (`api.atlassian.com/graphql` vs. the gateway/instance
     binary split). Flagging here only for completeness/cross-reference — this
     is already tracked, not a new finding.
   - `exit_code()` mapping in `src/error.rs`: `NotAuthenticated` and
     `InsufficientScope` both map to exit code 2, consistent with the rest of
     the auth-error family.

6. **New `unwrap()`/`expect()` in cycle-008-touched production code:** two
   pre-existing invariant-justified `.expect()` calls in `sprint.rs`/`list.rs`
   (`"clap enforces --sprint when --current is absent"`,
   `"asset.id.is_some() checked above"`) — both are the standard
   invariant-proof-in-message style already used throughout the codebase, not
   new bare `.unwrap()` calls. No unjustified panics introduced.

## Verdict

No batch-refactor-worthy pattern drift beyond item 1 (LOW, 3-line mechanical
fix). Codebase remains consistent with its documented conventions after
cycle-008.
