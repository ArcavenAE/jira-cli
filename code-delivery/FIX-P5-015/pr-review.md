## PR #910 review: claim audit of the `field.rs::handle` rustdoc

**Verdict: APPROVE**
**Covered SHA:** `f55833c79bf3fbf8906ed85f1a9b3fa2365f17fc`

### Scope check
`git diff origin/develop...f55833c7` touches one file, `src/cli/field.rs`, at lines 102-108 (+7/-16). Every changed line is a `///` doc comment on `handle`. The diff changes no code, tests or behavior.

### Each sentence checked against the code at the head commit
| Claim | Verified against | Result |
|---|---|---|
| "resolves `<field>` to a field id via `resolve_field_id`" | `handle`: `let field_id = resolve_field_id(client, profile, &field).await?;` | True |
| "...which may read or refresh the per-profile fields cache and call `GET /field`" | `resolve_field_id`: literal or empty input returns early. Otherwise it calls `cache::read_fields_cache(profile)?`, then `client.list_fields()` (`GET /rest/api/3/field`), then `cache::write_fields_cache` | True. "may" covers the literal and empty short-circuits. It no longer says when a refetch happens, so it repeats none of the CR13-001 wording ("missing or unreadable") |
| "then dispatches on the mode flag — M1 editmeta, M2 createmeta, M3 JSM request-type fields" | `match mode { Createmeta / RequestType / Editmeta }` | True. The arity check runs before resolution, but the dispatch itself runs after, so the order stated is correct |
| "Each mode path may resolve a project, read or write caches, and make HTTP calls" | M2/M3: `resolve_m2_project` (exit 64 before any HTTP if it fails). M3: `require_service_desk` (project-meta cache), `list_request_types`, `get_request_type_fields`. M2: `get_issue_types_for_project` and `get_createmeta_fields` (both uncached). M1: `get_editmeta` (uncached) | True as a hedged statement. It no longer says HTTP always runs, which fixes P13-001 |
| "as documented on that path's own helpers" | The rustdoc for `resolve_m2_project`, `require_service_desk`, `get_issue_types_for_project` ("No cache"), `get_createmeta_fields` ("Not cached"), `get_editmeta` ("NOT cached") and `get_request_type_fields` | True |
| "before rendering to stdout/stderr" | `output::print_output(...)` at the end of `handle` | True |
| BC-X.14.001 Invariant 2: read-only | Every call in all three paths is a GET | True (paragraph unchanged) |

### Findings
No blocking findings.

- **[NIT] N1: `src/cli/field.rs:104` ("see its docs").** The new text sends readers to `resolve_field_id`'s rustdoc (lines ~430-444). That rustdoc says the fallback happens "on a cache miss or a field absent from the cached list". It does not say that a stale (TTL-expired) or unparseable cache also counts as a miss, or that other I/O errors from `read_fields_cache` propagate through `?`. None of that is false, because those cases come back from `read_cache` as `Ok(None)`. Still, the document readers are now pointed to is less precise than the CR13-001 discussion. This text is outside the diff, so it can be a follow-up.
- **[NIT] N2: `src/cli/field.rs:106-107`.** "Each mode path may resolve a project, read or write caches". For M1 (`--issue`), none of these happen: no project resolution and no cache, only an uncached `get_editmeta`. Because of the "may", the sentence is not false, but "Each" applies the whole list to every path. One possible wording: "M2/M3 resolve a project first; mode paths may read or write caches and make HTTP calls..."
- **[NIT] N3: `src/cli/field.rs:107-108`.** "before rendering to stdout/stderr". On error paths `handle` renders nothing itself; `main` prints the error. Cache-write warnings go to stderr from inside the cache layer, during the mode path rather than after it. This is fine for a summary, and noted only for completeness.
