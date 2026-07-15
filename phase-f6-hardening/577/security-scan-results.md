---
phase: f6-targeted-hardening
dimension: security-scans
bundle: SOH-COMMENT-CRUD-1
issue: "#577"
head_sha: ae2e3db
pre_bundle_base: b2ce3169
tools:
  - cargo deny check (PASS — advisories/bans/licenses/sources ok, exit 0)
  - cargo audit (PASS — 347 crates scanned, 0 vulnerabilities, exit 0)
  - semgrep (SKIP — not installed on host; manual grep audit performed)
  - manual delta security pass (id-in-URL, key-encoding, stdin/file, prompt gate, properties injection, error-body)
findings: 0 CRITICAL, 0 HIGH, 0 MEDIUM, 0 LOW (new)
prior_adjudicated: SEC-577-001..008 (all LOW/INFO, F2 security-review-577.md; carried forward, verified holding)
date: 2026-07-14
verdict: PASS
---

# F6 Dimension 4 — Security Scanning (SOH-COMMENT-CRUD-1)

## 4a. cargo deny check (project standard)

Command: `cargo deny check`

```
advisories ok, bans ok, licenses ok, sources ok
```

Exit code: **0** (verified: `cargo deny check >/dev/null 2>&1; echo $?` → 0).

3 non-fatal `license-not-encountered` warnings (unmatched allowances for
`BSD-2-Clause` / `Unicode-DFS-2016` / `OpenSSL`) — identical to the pre-bundle
baseline. No delta-attributable finding.

## 4b. cargo audit

Command: `cargo audit`

```
      Loaded 1160 security advisories (from ~/.cargo/advisory-db)
    Scanning Cargo.lock for vulnerabilities (347 crate dependencies)
```

Exit code: **0**. **0 vulnerabilities across 347 crate dependencies.** The
bundle adds no new dependency (the three API methods reuse the existing
`JiraClient` get/put/delete plumbing; `urlencoding` was already a dependency).

## 4c. Semgrep

Not installed on the host (`which semgrep` → not found). Justified skip — the
project's CI-side static-analysis standard is cargo-deny + cargo-audit + clippy
(`-D warnings`); semgrep is not in the project pipeline. Same skip as every prior
F6 cycle. Manual substitute performed below.

## 4d. Manual delta security pass

Scope: `src/cli/issue/interactions.rs`, `src/api/jira/issues.rs`
(`delete_comment`/`update_comment`/`get_comment`), `src/main.rs` intercept +
`JR_STDIN_IS_TTY` seam. Prior findings for this bundle are recorded in
`.factory/phase-f2-spec-evolution/security-review-577.md` (SEC-577-001..008)
and the per-story reviews at `.factory/code-delivery/S-577-*/pr-review.md`. F6
independently re-verified each attack surface against the shipped code.

### 4d-1. Comment-id in raw URL path — CWE-1283 / CWE-20 (PRIMARY surface)

The three new API methods interpolate `id` **raw** (not percent-encoded) into
the URL path — confirmed in the rustdoc precondition on each
(`…it is interpolated raw into the URL path`). This is safe **only** because
every caller validates `id` first:

| Handler | `validate_comment_id` call | HTTP call | Order OK |
|---------|---------------------------|-----------|----------|
| `handle_comment_delete` | line 145 | `delete_comment` line 201 | ✅ before |
| `handle_comment_edit` | line 366 | `update_comment` line ~515 | ✅ before |
| `handle_comment_view` | line 594 | `get_comment` line 597 | ✅ before |

`validate_comment_id` (line 107) enforces `^[0-9A-Za-z_-]+$` with an explicit
empty guard. The F6 transient proptest probe
(`f6probe_validate_id_accepts_only_url_safe`, 4,000 cases, `fuzz-results.md`)
proved that no accepted id can contain `/ ? # % . space \ & : @` — so path
traversal, query-string injection, fragment injection, and percent-encoding
smuggling are all structurally impossible on the id segment. Existing unit
tests pin the rejections (`test_validate_comment_id_rejects_slash` → `../etc/passwd`,
`_rejects_space`, `_rejects_dot`). This corresponds to the F2 CWE-1283 posture
(`SEC-577-002` scope) and is now enforced at runtime for all three verbs.

### 4d-2. Issue-key URL-encoding — EC-3.5.002-2 (VP-577-027)

All three API methods encode the key via `urlencoding::encode(key)`
(`issues.rs` lines 604 / 634 / 661). A key containing a space (`MY KEY-1`)
becomes `MY%20KEY-1` on the wire — pinned by VP-577-027
(`test_bc_3_5_002_ec2_delete_key_url_encoding`) at the CLI level and
`test_delete_comment_encodes_key_with_space_in_url` at the API level. No
key-injection surface.

### 4d-3. stdin / file body sources — CWE-20

Comment body sources: stdin via `tokio::task::spawn_blocking` (runtime-safe
blocking read, both add and edit paths); `--file` via `std::fs::read_to_string`
with `NotFound → exit 64 UserError` remap and all other IO errors propagated
(no misleading "file not found" for permission-denied / is-a-directory). All
body text flows into the existing `markdown_to_adf` / `text_to_adf` pipelines,
which carry the `MAX_ADF_DEPTH = 256` recursion guard (SEC-001, CWE-674,
BC-7.2.012) and the INV-1 CR/LF normalization (BC-7.2.011). This is exactly the
F2 posture for `SEC-577-007` (INFO / covered by SEC-001) — the bundle adds no
new ADF surface (`src/adf.rs` unchanged).

### 4d-4. Confirmation prompt gate — CWE-1021 (SEC-577-001)

Delete and `--public` edit guard the risky (data-exposing) direction only.
Mechanism (DEC-174): `eprint!` prompt to **stderr** + `io::stdin().lock().read_line()`;
EOF/error → `JrError::Interrupted` (exit 130). `--internal` (making a comment
less visible) needs no gate; `--yes` bypasses the `--public` gate and is a
no-op otherwise (VP-577-028). The non-interactive `--public` message uses
project-agnostic wording (`"visibility to public"`) per the SEC-577-001
CWE-1021 fix (the prompt does not misrepresent a JSM-specific effect as
universal). `--stdin` forces `no_input = true` at the gate (EC-3.5.008-3,
TTY-agnostic) so a stdin already consumed for the body cannot be re-read for a
prompt answer. Consistent with SEC-577-001 / DEC-169 as cited in
`.factory/code-delivery/S-577-5/pr-review.md` §10.

### 4d-5. `sd.public.comment` properties injection

`update_comment` builds `properties` from a fixed literal key
(`"sd.public.comment"`) and a boolean-typed `internal` value derived from the
`--internal`/`--public` flags — never from user-supplied strings. VP-577-002/003
pin the exact wire shape (`internal` is a JSON boolean, not the string
`"true"`/`"false"` — the JSDCLOUD-9766 red flag) and the single-element array
cardinality + exact key name. When neither flag is set, the `properties` key is
absent entirely (body-only PUT, VP-577-001) — no clobbering of unrelated
comment properties (the MERGE gotcha in CLAUDE.md). No user-controlled property
key/value reaches the wire.

### 4d-6. Error-body surfacing — CWE-209 (SEC-577-006)

404/403 handlers re-wrap `JrError::ApiError` into `JrError::UserError` (exit 64)
and surface the Jira `errorMessages` body on a second stderr line. Per F2
`SEC-577-006` (INFO / accepted): the Jira 404 comment body
(`{"errorMessages":["Comment with id 'X' does not exist."]}`) carries no
accountId/email/ADF, and this matches the project-wide `extract_error_message`
convention (BC-7.3.001/002). Accepted per convention; no PII escalation.

### 4d-7. `unsafe` / panic / exit surface

- `grep -nE '\bunsafe\b'` over the delta (all files) → **0 added**.
- `interactions.rs` non-test `.unwrap()`/`.expect()` → **0**. Two
  `unreachable!()` arms exist (variant destructure in `handle_comment_add`/
  `handle_comment_edit`) but are provably unreachable: `mod.rs` dispatch routes
  only `Add`→add and `Edit`→edit.
- `issues.rs` delta added `.unwrap()`/`.expect()` → **0**.
- `main.rs` delta: 2 `std::process::exit(2)` in the `InvalidSubcommand`
  intercept — identical exit semantics to clap's own `err.exit()` (usage error →
  stderr + exit 2); reviewed, not a concern.

### 4d-8. `JR_STDIN_IS_TTY` debug seam

The seam is `#[cfg(debug_assertions)]`-gated at the read site in `src/main.rs`
(release builds hard-code `false`), regression-pinned by
`tests/jr_stdin_is_tty_release_gate.rs` (window search asserting the cfg-gate is
adjacent to the env-var read — same pattern as `JR_BASE_URL`/`JR_CONFIG_DIR`
gates). No release-binary behavior change; no token-leak class (it only
suppresses the auto-`--no-input` flip in debug).

## Findings

**0 new CRITICAL / HIGH / MEDIUM / LOW.** All prior SEC-577-001..008 findings
(LOW/INFO, F2) were verified still holding in the shipped code. No
`security-reviewer` escalation (only HIGH/CRITICAL trigger the gate). No BLOCK
condition.

## Verdict

**PASS** — cargo deny + cargo audit clean (exit 0, 0 vulns); the delta's primary
new surface (raw comment-id in URL) is structurally defended by a URL-safe
charset validator enforced before every HTTP call and proptest-verified; key
encoding, prompt gate, properties injection, and error-body surfacing all match
their adjudicated F2 postures; no new unsafe/panic/dependency surface.
