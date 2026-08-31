---
phase: F6
scope: field-dx delta (S-578-1..4, S-580-1) — develop @ 91d04fe1..4e4ae4f5 (HEAD 4e4ae4f5)
reviewer: security-reviewer
total_findings: 3
critical: 0
high: 0
medium: 0
low: 3
files_reviewed: 8
verdict: CLEAN — no CRITICAL/HIGH findings; 3 LOW findings documented, none blocking
---

# Phase F6 Security Scan — field-dx delta

## Scope

Commits reviewed: `993de833` (S-578-1 parser), `74221bbc` (S-580-1 `jr field
options`), `a3739763` (S-578-3 edit dispatch), `41763ff0` (S-578-4 JSM
`:asset`), `ae8514b8` (S-578-5 create createmeta), `4e4ae4f5` (F5-001
pagination bound fix) — `develop` @ 91d04fe1 → 4e4ae4f5.

Files: `src/cli/issue/field_resolve.rs`, `src/cli/issue/create.rs`,
`src/cli/issue/jsm_create.rs`, `src/cli/issue/edit.rs`, `src/cli/field.rs`
(new file), `src/api/jira/issues.rs`, `src/api/jsm/requests.rs`,
`src/types/jira/editmeta.rs`.

Diff size: 8 files changed, 4,097 insertions(+), 281 deletions(-).

## 1. Dependency audit (full tree)

**`cargo deny check`** (v0.19.6, `deny.toml`): `advisories ok, bans ok,
licenses ok, sources ok`. Only informational warnings about unmatched
license-allowance/skip entries in `deny.toml` (pre-existing config hygiene,
unrelated to this delta) — no blocking finding.

**`cargo audit`** (v0.22.1, 1,233 advisories loaded, 358 crates scanned): 0
vulnerability advisories. One warning: `chacha20 0.10.0` (transitive via
`rand 0.10.2`) is marked **yanked** upstream — not a vulnerability advisory,
and `deny.toml` already carries an authorized skip/reason for the sibling
`cpufeatures` version-split this same `rand`/`chacha20` pairing causes
(DEC-185). Pre-existing, not introduced by this delta.

**Confirmed no new dependency surface:** `git diff 91d04fe1..4e4ae4f5 --
Cargo.toml Cargo.lock` is **empty** — the field-dx delta added zero new
third-party crates. All new attack surface is first-party Rust code
consuming existing HTTP/serde/URL-encoding infrastructure.

## 2. Static scan (semgrep)

`semgrep` is **not installed** in this environment (`command not found`).
No `semgrep --config=auto` run was possible. Proceeded with manual
CWE/OWASP review per the task's fallback instruction. Recommend the
orchestrator run semgrep in a follow-up CI/toolchain context if automated
static-analysis coverage on this delta is required before release.

## 3. Manual CWE/OWASP review

| ID | Severity | CWE | File:Location | Description |
|----|----------|-----|----------------|-------------|
| SEC-F6-1 | LOW | CWE-617 (Reachable Assertion) / CWE-248 | `src/api/jsm/requests.rs::compose_asset_wire` | Panics (`unwrap_or_else` + `panic!`) if `value` lacks a `:` separator. Documented as an internal-invariant guard: the sole production caller (`jsm_create.rs::resolve_asset_field_l2`) always returns an already-qualified `WORKSPACE:OBJECTID` string on every code path, so this is unreachable today (confirmed via `grep` — `JsmRequestBuilder` has exactly one non-test call site). Risk: a future refactor that feeds `JsmRequestBuilder.extra_fields` from a different, less-disciplined call site would reintroduce a DoS-by-panic on the JSM create path (crashes the single CLI invocation; no remote/multi-user impact) instead of a graceful `Result` error. **Disposition: accepted-as-documented** — matches the codebase's existing `unreachable!()`/invariant-`expect()` convention (e.g. `field.rs`'s `Mode::*` dispatch `.expect()` calls, `handle_create`'s `else { unreachable!() }`), not a new anti-pattern. No fix required to unblock F6; consider converting to a `Result`-propagated `JrError::Internal` in a future hardening pass for defense-in-depth. |
| SEC-F6-2 | LOW | CWE-674 (Uncontrolled Recursion) | `src/types/jira/editmeta.rs::AllowedValue.children` (new field, `#[serde(default)] Vec<AllowedValue>`) and `src/cli/field.rs` M3 path (`normalize_from_valid_values` walks untyped `serde_json::Value` from `validValues`) | `AllowedValue.children` is a new recursive field populated directly from the Jira server response during `serde_json` deserialization — recursion depth at *deserialization* time is bounded only by the process call stack, not by the module's own `MAX_FIELD_OPTION_DEPTH = 256` guard, which only bounds *post-deserialization* tree-walks (`normalize_from_allowed_values`, `normalize_from_valid_values`, `filter_one`, `render_rows_recursive` — all correctly guarded, verified). A pathologically deep `children`/`validValues` nesting in a server response (requires a compromised or MITM'd Jira Cloud instance — same trust boundary as every other typed API response in this codebase, e.g. `Issue`, `Board`, `Sprint`, none of which have deserialization-time recursion guards either) could in principle exhaust the stack before the app-level guard ever runs. **Disposition: consistent with existing accepted risk, not a new regression** — this mirrors the same class CLAUDE.md documents as accepted for `adf.rs`'s `MAX_ADF_DEPTH` (SEC-001, CWE-674), which bounds construction/render of ADF trees post-parse, not raw JSON deserialization depth either. No fix required for F6; not delta-introduced in kind, only in one additional struct. |
| SEC-F6-3 | LOW | CWE-20 (Improper Input Validation) — informational | `src/cli/issue/field_resolve.rs::compose_asset_hint`, `src/cli/issue/jsm_create.rs::resolve_asset_field_l2` | The user-supplied `WORKSPACE` segment of an explicit `--field NAME:asset=WORKSPACE:OBJECTID` value is validated only for non-emptiness and absence of a second `:` — no format/charset check (e.g. UUID shape) before being placed into the `workspaceId`/`id` JSON fields of the outbound POST body. This is **not an injection vector** (the value is serialized via `serde_json::json!`, which JSON-escapes strings correctly — no raw string concatenation into a request anywhere in the reviewed diff), and it does not affect a URL/host (no SSRF potential — the value is a JSON body field sent to the already-authenticated, already-pinned Jira base URL, never used to construct a request target). Worst case is a well-formed-but-invalid JSON body that Jira's own server-side validation rejects with a 4xx. Documented for completeness per the task's `:asset` composition review ask; **no fix required**. |

### Other reviewed surfaces — no findings

- **`parse_field_kv` (`create.rs`)** — pure string parser, no HTTP/IO. All
  splitting is Unicode-scalar-safe (`str::find(char)`/`str::rfind(char)`,
  never raw byte-index slicing — explicitly engineered to avoid the
  FIX-F6-LRE-1 panic class from issue #734). Closed-set validation
  (`{option, id, name, asset}`, case-sensitive) on the kind tag with a
  clean exit-64 `UserError` on anything else. No injection surface: output
  is a `HashMap<String, FieldValueSpec>` consumed downstream via
  `serde_json::json!`, never string-concatenated into a request.
- **`:asset` `WS:OBJ` composition** — `objectId` is validated
  ASCII-digits-only (`chars().all(|c| c.is_ascii_digit())`) in every branch
  before being placed in the wire body; empty/malformed shapes are rejected
  with exit-64 `UserError`s in a documented, deterministic precedence order
  (empty → empty-workspace-segment → extra-colon → non-numeric objectId).
  Workspace-id resolution (`get_or_fetch_workspace_id`) is called at most
  once per invocation and only on the bare-objectId path; on a cold cache
  its own 403/404/401/5xx/network taxonomy is propagated via `?`, not
  swallowed or re-worded to leak anything additional.
- **Cascading `:option` `Parent>Child` split** — `str::split_once('>')`
  (Unicode-safe, single-pass). Empty-parent and empty-child segments are
  each explicitly rejected before any lookup runs (EC-3.4.027-6). Non-
  cascading-field `>` collision is detected structurally
  (`parent_av.children.is_empty()`), never via a spoofable `schema.type`
  string compare. No injection surface — output feeds
  `find_option_match`/`serde_json::json!`, never raw string interpolation
  into a request.
- **`jr field options` (`field.rs`, new command, read-only)** — confirmed
  strictly read-only (zero mutating HTTP under any invocation, per the
  module's own Invariant 2 doc comment and the M1/M2/M3 dispatch arms, all
  of which only call `GET`-style client methods). Mode-selector arity
  (`--type`/`--request-type`/`--issue`) is validated purely, before any
  HTTP call. All three context-resolution paths (M1 editmeta, M2
  createmeta, M3 JSM requesttype-fields) route project/issue/field-id
  segments through `urlencoding::encode()` at every new endpoint
  construction site (`get_editmeta`, `get_issue_types_for_project`,
  `get_createmeta_fields`, `get_request_type_fields`) — verified by direct
  code read, consistent with the rest of the codebase's existing
  convention. Recursion guard `MAX_FIELD_OPTION_DEPTH = 256` (CWE-674,
  explicitly modeled on `adf.rs`'s `MAX_ADF_DEPTH` precedent) is correctly
  wired into all four recursive functions
  (`normalize_from_allowed_values_at_depth`,
  `normalize_from_valid_values_at_depth`, `filter_one`,
  `render_rows_recursive`) — confirmed via grep that every recursive call
  site checks `depth >= MAX_FIELD_OPTION_DEPTH` before descending, with
  regression-pinning unit tests asserting truncation starts exactly at
  depth 256 (inclusive boundary, matching the `adf.rs` DEC-132 lesson about
  off-by-one `>` vs `>=` boundary bugs).
- **createmeta pagination (`get_createmeta_fields` /
  `get_issue_types_for_project`, `src/api/jira/issues.rs`)** — both bounded
  by `MAX_CREATEMETA_PAGES = 500` (page_size 200 → 100,000-entry practical
  ceiling), checked at the **top of every loop iteration independent of the
  `done` computation** — i.e. even a fully-defeated/mutated termination
  heuristic cannot produce an unbounded loop, since the page-count check is
  a structurally separate backstop (explicitly the design rationale in the
  F5-001 commit this scan's HEAD includes, which mirrors S-580-1's
  original CWE-400/770 guard onto the sibling issue-types function). Empty-
  page-while-`total`-not-yet-reached is separately handled (the
  JRACLOUD-71293/95368 permission-filtered-short-page class) to avoid a
  zero-advance infinite loop even within one otherwise-legitimate
  pagination session. No resource-exhaustion finding.
- **Error messages / PII / credential leakage** — reviewed every new
  `format!`/error-string construction across the 8 files. All interpolate
  only locally-known, already-user-supplied values (field names, `--field`
  pair text, project/issue keys, resolved option labels) or `JrError`
  status codes — never raw HTTP response bodies, tokens, `Authorization`
  headers, or keychain contents. `git diff` grep for
  `JR_BASE_URL|verbose_bodies|Authorization|api_token|password` inside the
  delta returns zero net-new matches (the one hit, `accountId`, is an
  unmodified comment/line carried through a pure code move, not new
  logic). `--verbose-bodies` gating and the PII warning it emits are
  untouched by this delta — the new code paths do not add any additional
  body-logging or bypass of that gate.
- **Debug-only env seams (`JR_BASE_URL`, `JR_CONFIG_DIR`, `JR_CACHE_DIR`,
  etc.)** — confirmed via diff grep that none of the seam definitions,
  their `#[cfg(debug_assertions)]` gates, or their release-gate test pins
  are touched anywhere in this delta. No weakening.

## Overall verdict

**CLEAN.** No CRITICAL or HIGH findings — no BLOCK. `cargo deny`/`cargo
audit` both pass with only pre-existing, already-authorized informational
warnings unrelated to this delta, and the delta introduces zero new
third-party dependencies. Three LOW findings are documented above, all
either already-mitigated-by-design, consistent with existing accepted risk
elsewhere in the codebase, or purely informational (no exploitable path
identified). semgrep was unavailable in this environment; manual CWE/OWASP
review substituted per the task's fallback instruction and covered every
named new input-handling entry point.
