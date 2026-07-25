---
document_type: f7-traceability-chain-delta
bundle: SOH-ATTACHMENTS-1
feature: "Attachment CRUD: list / download / upload / delete (issues #576 + #585)"
spec_version: v1.3.106
bc_index_version: v6.44
story_index_version: v1.5.40
develop_sha: db207b81
date: 2026-07-25
producer: fresh-context F7 audit agent
---

# F7 Traceability Chain Delta — SOH-ATTACHMENTS-1

Four-level chain for every BC in the SOH-ATTACHMENTS-1 delta:
**BC → VP (where allocated) → representative test(s) → src symbol → review evidence**

Delta = BC-2.7.001..012 (§2.7 Attachment Read, 12 BCs) + BC-3.9.001..020 (§3.9 Attachment Write, 20 BCs) + BC-X.8.010 (1 BC) + FIX-576-DL emergent fix = 34 items.

depends_on edges: S-576-5 depends_on S-576-3 (stale-ID self-heal gate mechanics, BC-X.8.010 path shared);
VP-576-004 upload half depends_on S-576-1 (curated-serialization plumbing, R3.13 earliest-consumer);
VP-576-005 depends_on S-576-3 (replace-existing gate mechanics).

---

## S-576-1: Attachment List (PR #630 @ e33624c1, 2026-07-19)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|--------------------|-----------|-----------------------|
| BC-2.7.001 | `attachment list <KEY>` 6-column table; zero-attach stderr hint; profile 2 | — | `tests/attachment_list.rs::test_bc_2_7_001_*` | `src/cli/issue/attachments.rs::handle_attachment_list` | Step 4.5 CONVERGED STRICT (4 passes, p2/p3/p4 window); CI run 29705120305 15/15 |
| BC-2.7.002 | `--output json` curated shape `[{author,contentUrl,created,filename,id,mimeType,size}]`; BTreeMap-alphabetical; `"self"` omitted; `"content"`→`"contentUrl"` | VP-576-004 (list half) | `tests/attachment_list.rs::test_bc_2_7_002_json_output_curated_shape` (lines 365–471); VP assertions at lines 457–471 | `src/api/jira/attachments.rs::list_attachments`; `src/output.rs::render_json` | Step 4.5 STRICT; VP-576-004 list-half discharged at S1 (P24-002); F5-pass-1 P1-002 author-curated-form ruling (spec v1.3.95) |
| BC-2.7.003 | `--filter mime=<glob>` client-side; AND-combined; filter-count hint | — | `tests/attachment_list.rs::test_bc_2_7_003_*` | `src/cli/issue/attachments.rs::handle_attachment_list` | Step 4.5 STRICT |
| BC-2.7.004 | `--filter name=<glob>` client-side filename filter | — | `tests/attachment_list.rs::test_bc_2_7_004_*` | `src/cli/issue/attachments.rs::handle_attachment_list` | Step 4.5 STRICT |
| BC-2.7.005 | `--filter size-max=<bytes>` client-side size filter; parse-error exit 64 | — | `tests/attachment_list.rs::test_bc_2_7_005_*` | `src/cli/issue/attachments.rs::handle_attachment_list` | Step 4.5 STRICT |
| BC-2.7.006 | Unknown/inaccessible KEY error taxonomy (404/401/5xx/network) | — | `tests/attachment_list.rs::test_bc_2_7_006_*` | `src/api/jira/attachments.rs::list_attachments` | Step 4.5 STRICT |
| BC-2.7.011 (display, earliest consumer) | `display_sanitize_filename` CWE-116 TTY sanitization; ASCII controls + Unicode bidi/line-sep/NEL → `?`; earliest consumer = S1 list table cells (v1.3.81/94 corrections) | VP-576-001 (proptest, lives in S2) | `tests/attachment_list.rs::test_bc_2_7_001_*` (table cells); unit tests in `src/cli/issue/attachments.rs` (Unicode cases U+202E/U+2028/U+0085) | `src/cli/issue/attachments.rs::display_sanitize_filename` | Step 4.5 STRICT; PRE-F4-UNICODE-DISPLAY-SANITIZATION ruling v1.3.94; SEC-576-011; earliest-consumer corrected S2→S1 (v1.3.81 r43) |

---

## S-576-2: Attachment Download (PR #631 @ efa8b5d9, 2026-07-20)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|--------------------|-----------|-----------------------|
| BC-2.7.007 | Single-file two-step download (metadata GET + content GET); no `?redirect=false`; streaming; write-to-tmp then atomic rename; overwrite-refuse + `--force`; `--out <PATH>` pre-flight before step-1; JSM uniform (JSDCLOUD-10841) | VP-576-001 (proptest containment anchor) | `tests/attachment_download.rs::test_bc_2_7_007_two_step_streaming_wire_path`; `test_bc_2_7_007_no_redirect_false_param`; `test_bc_2_7_007_auth_absent_on_redirect_target`; `test_bc_2_7_007_out_preflight_before_get_p32_001` | `src/cli/issue/attachments.rs::handle_attachment_download`; `src/cli/issue/attachments.rs::stream_to_file` | Step 4.5 STRICT (12 passes / 9 fix rounds; B2 Windows drive-prefix catch; CI mutation 94%); F5-R3 HIGH BC-2.7.012 download-404 canonical-only fix; F5-R8/R9 deliberate-asymmetry ruling |
| BC-2.7.008 | `--all` batch download to `--out-dir`; fail-soft per-file; collision resolved SHA-1 prefix; JSON mode `{"downloaded":[...]}` | — | `tests/attachment_download.rs::test_bc_2_7_008_*` | `src/cli/issue/attachments.rs::handle_attachment_download` | Step 4.5 STRICT |
| BC-2.7.009 | `--newest N` top-N by `created` desc; filter before top-N; RFC3339 compare | — | `tests/attachment_download.rs::test_bc_2_7_009_*` | `src/cli/issue/attachments.rs::handle_attachment_download` | Step 4.5 STRICT; F5-R1 RFC3339 --newest parser fix (F5-R1-003 partial) |
| BC-2.7.010 | Default output path `<sha1-of-id(40 hex)>_<sanitized-basename>`; `--out <PATH>` bypasses | — | `tests/attachment_download.rs::test_bc_2_7_010_*` | `src/cli/issue/attachments.rs::compute_default_output_path` | Step 4.5 STRICT |
| BC-2.7.011 (disk-path CWE-22) | `sanitize_attachment_filename` 5-step algorithm: basename extraction, pseudo-name reject, NUL reject, char scrub, 214-byte UTF-8 cap; containment via `starts_with(canonicalize(out_dir))`; Windows device-name caller note | VP-576-001 (proptest — primary) | `tests/attachment_download.rs` lines 3089–3115 proptest; unit pins in `src/cli/issue/attachments.rs` inline (lines 3248+) | `src/cli/issue/attachments.rs::sanitize_attachment_filename` | Step 4.5 STRICT; SEC-576-001/002/007; P14-007; mutation exemption via `.cargo/mutants.toml` `examine_globs`; F6 D2 fuzz 16,384 cases 0 panics |
| BC-2.7.012 | Error taxonomy: KEY 404/403 batch-only (batch paths only; `--id` no server-verify); AID 404/403 targeted; disk-write errors via `classify_write_error` (`StorageFull\|QuotaExceeded`, `PermissionDenied\|ReadOnlyFilesystem`, generic); v1.3.102/103/104 HYBRID string shape | — | `tests/attachment_download.rs::test_bc_2_7_012_*`; `src/cli/issue/attachments.rs` lines 3248–3320 (classify_write_error unit tests) | `src/cli/issue/attachments.rs::classify_write_error`; `src/cli/issue/attachments.rs::stream_to_file` | F5-R5 research-backed disk-error taxonomy; F5-R6 io-site count 3→4 + flush delayed-allocation; FIX-F5-010 Windows P9-001 permission-denied parenthetical; spec v1.3.102/103/104 |

---

## FIX-576-DL: AttachmentMetadata.id integer/string drift (PR #642 @ 7298c035, 2026-07-23)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|--------------------|-----------|-----------------------|
| BC-2.7.007 (serde fix) | `AttachmentMetadata.id` accepts JSON integer OR string (live Jira vs mock drift JRACLOUD-equivalent); `deserialize_string_or_int_as_string` normalizes both to `String` | — | `tests/attachment_download.rs::test_download_integer_id_in_metadata_succeeds` (line 3245); `test_download_string_id_in_metadata_still_succeeds` (line 3307) | `src/api/jira/attachments.rs::deserialize_string_or_int_as_string` | Found by S-576-6 live validation run 30031724733 (96/97 FAIL); fixed in FIX-576-DL; mutation 100% kill (9/9); e2e re-run 30041659024 green |

---

## S-576-3: Platform Upload + replace-existing + dry-run (PR #635 @ f2d3b378, 2026-07-21)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|--------------------|-----------|-----------------------|
| BC-3.9.001 | Platform POST multipart; `X-Atlassian-Token: no-check` mandatory (SEC-576-003); streaming; no size cap; 413/400 error mapping; 4-column echo table; `--dry-run` requires `--replace-existing` | — | `tests/attachment_upload.rs::test_bc_3_9_001_*`; `test_sec_576_004_content_disposition_crlf_injection_guard` | `src/cli/issue/attachments.rs::handle_attachment_upload`; `src/api/jira/attachments.rs::upload_attachments` | Step 4.5 STRICT (7 passes / 4 fix rounds; p5/p6/p7 CLEAN×3; P2-003 HIGH DELETE-404 abort bug fixed); CI mutation 97% |
| BC-3.9.002 | Upload to JSM issue without `--public`/`--internal` → platform POST (safe default; zero servicedeskapi calls) | — | `tests/attachment_upload.rs::test_bc_3_9_002_*` | `src/cli/issue/attachments.rs::handle_attachment_upload` | Step 4.5 STRICT |
| BC-3.9.007 (EC-3.9.007-1 platform) | Platform POST echo: curated form (BC-2.7.002 authority); `self` omitted, `content`→`contentUrl`; R3.13 earliest-consumer principle | VP-576-004 (upload-POST half) | `tests/attachment_upload.rs::test_bc_3_9_009_*` (VP-576-004 upload assertions) | `src/cli/issue/attachments.rs::handle_attachment_upload` | P24-002 story-allocation: upload-POST half verified at S3; depends_on S1 for shared serialization plumbing |
| BC-3.9.008 | AID validated `^[0-9]+$` before any HTTP; DELETE 204→exit 0; 404→exit 64 + Jira body (DEC-168); SEC-576-004 CRLF/NUL guard | — | `tests/attachment_upload.rs::test_bc_3_9_008_*` | `src/api/jira/attachments.rs::delete_attachment`; `src/api/jira/attachments.rs::delete_attachment_targeted` | Step 4.5 STRICT |
| BC-3.9.009 | `--output json` upload: same curated array shape as BC-2.7.002 (VP-576-004 authority) | VP-576-004 (upload-POST half) | `tests/attachment_upload.rs::test_vp_576_004_*` | `src/cli/issue/attachments.rs::handle_attachment_upload` | P24-002; VP-576-004 cross-path invariant |
| BC-3.9.012 (platform branch) | Upload error taxonomy: file-not-found, issue 404, non-interactive-no-yes, 413, 403, 400, 401, 5xx, network | — | `tests/attachment_upload.rs::test_bc_3_9_012_*` | `src/cli/issue/attachments.rs::handle_attachment_upload` | Step 4.5 STRICT |
| BC-3.9.013 | Delete error taxonomy: invalid AID non-numeric exit 64 zero HTTP (CWE-88); 404 exit 64 (DEC-168); 403/401/5xx/network | — | `tests/attachment_upload.rs::test_bc_3_9_013_*` | `src/api/jira/attachments.rs::delete_attachment_targeted` | Step 4.5 STRICT; DEC-168 asymmetry from delete_attachment (benign-skip) |
| BC-3.9.014 | `--public` confirmation gate mechanics: `eprint!`+`read_line`; ≤3 filenames or "N files"; three consumers (standalone/replace/combined); three non-interactive exit-64 variants | — | `tests/attachment_upload.rs::test_bc_3_9_014_*` | `src/cli/issue/attachments.rs::handle_attachment_upload` | Step 4.5 STRICT; P14-001/P20-002 |
| BC-3.9.017 | `--replace-existing`: same-filename lookup; ≥1-match confirmation gate; non-interactive exit 64 (two sub-variants A/B); combined `--public` single-prompt; zero-matches no gate; DELETE then POST ordering (VP-576-003); VP-576-005 story allocation verified at S5 | VP-576-003 (ordering) | `tests/attachment_upload.rs::test_vp_576_003_delete_before_post_ordering_invariant` (lines 1917–2014) | `src/cli/issue/attachments.rs::handle_attachment_upload` | Step 4.5 STRICT; P15-002/R3.12 confirmation gate; P23-001 wire fix; P36-002 --yes skip |
| BC-3.9.018 | Zero-match `--replace-existing`: silent, proceed as plain upload | — | `tests/attachment_upload.rs::test_bc_3_9_018_*` | `src/cli/issue/attachments.rs::handle_attachment_upload` | Step 4.5 STRICT |

---

## S-576-4: Attachment Delete (PR #638 @ c28ae940, 2026-07-22)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|--------------------|-----------|-----------------------|
| BC-3.9.010 | `delete --output json` shapes: single/bulk; bulk 404 = benign-skip (EC-3.9.010-4, BC-3.9.013 precedent); all-404 human-mode "No attachments deleted" hint; single vs bulk 404 intentionally asymmetric | — | `tests/attachment_delete.rs::test_bc_3_9_010_*` | `src/cli/issue/attachments.rs::handle_attachment_delete` | Step 4.5 STRICT (11 passes / 5 fix rounds; p9/p10/p11 CLEAN×3; AC-009 fan-out; duration-overflow 3-band onion); CI mutation 97% |
| BC-3.9.015 | Single-AID interactive gate: AID validated before gate; `eprint!`+`read_line`; metadata-fetch before prompt; three-way branch (y/enter/EOF); --yes skips metadata GET; display-sanitized filename in prompt (SEC-576-011) | VP-576-002 (confirm/cancel) | `tests/attachment_delete.rs::test_bc_3_9_015_vp_576_002_confirm_*` (lines 362–418); cancel variant (lines 477–550) | `src/cli/issue/attachments.rs::handle_attachment_delete` | VP-576-002 confirm (exit 0, DELETE issued) + cancel (exit 0, JSON `{"cancelled":true,"deleted":false}`); F4 security review 0 CRIT/HIGH |
| BC-3.9.016 | `--older-than` ALWAYS requires `--yes`; multi-AID AID-validated; `--dry-run` exempt; clap mutual-exclusion; bulk 404 benign-skip | — | `tests/attachment_delete.rs::test_bc_3_9_016_*` | `src/cli/issue/attachments.rs::handle_attachment_delete` | Step 4.5 STRICT; P22-002 |
| BC-3.9.019 | `delete --older-than <duration>`: dedicated `parse_age_duration` (d=24h, w=7×24h); chrono client-side compare; invalid duration exit 64; JSON bulk shape; pre-deletion stderr summary HINT (JSON-suppressed) | — | `tests/attachment_delete.rs::test_bc_3_9_019_*` | `src/cli/issue/attachments.rs::handle_attachment_delete` (`parse_age_duration` private helper); `src/cli/issue/attachments.rs` | Step 4.5 STRICT; P26-004 location TBD resolved as private helper in attachments.rs |
| BC-3.9.020 | `--dry-run` taxonomy: confirmation gates SUPPRESSED; eligibility guards NOT suppressed; file pre-checks NOT suppressed; JSON shapes single/multi/upload; `--replace-existing --dry-run --public` non-JSM exits 64 before any list GET | — | `tests/attachment_delete.rs::test_bc_3_9_020_*` | `src/cli/issue/attachments.rs::handle_attachment_delete`; `src/cli/issue/attachments.rs::handle_attachment_upload` | Step 4.5 STRICT; P3-007 three-category taxonomy; P23-002 EC-3.9.020-8; P28-001 wire correction |

---

## S-576-5: JSM Visibility (--public / --internal) (PR #640 @ 0498e596, 2026-07-23)

| BC | One-liner | VP | Representative test | Src symbol | Review evidence |
|----|-----------|-----|--------------------|-----------|-----------------------|
| BC-3.9.003 | `--public` JSM two-step: Step 0 issue GET + `get_or_fetch_project_meta`; DEC-174 gate; non-interactive exit 64; cancel shape; Step-0 suppression on combined path; step-1 stale-ID self-heal (SEC-576-006) | VP-576-005 (combined-gate, depends_on S3) | `tests/attachment_jsm.rs::test_bc_3_9_003_*` | `src/cli/issue/attachments.rs::handle_attachment_upload_jsm` | Step 4.5 STRICT (9 passes / 6 fix rounds; p7/p8/p9 CLEAN×3; P2-3c DISCHARGED probe runs 29936980027+29940792930+29945857059); CI 14/14; mutation 94% kill |
| BC-3.9.004 | `--internal` JSM two-step public:false (OQ-9 non-JSM silent no-op); non-JSM OQ-9 → platform POST zero servicedeskapi; Step 0 skip on combined path | VP-576-005 (non-JSM zero-servicedeskapi assertion) | `tests/attachment_jsm.rs::test_bc_3_9_004_*`; H-NEW-ATTACHMENT-011 (`test_h_new_attachment_011_*`) | `src/cli/issue/attachments.rs::handle_attachment_upload_jsm` | Step 4.5 STRICT; OQ-9 ruling; P20-001; P21-004/005 |
| BC-3.9.005 | `--public` on non-JSM exits 64; canonical message; zero servicedeskapi calls; asymmetric from `--internal`; eligibility guard NOT dry-run-suppressed | — | `tests/attachment_jsm.rs::test_bc_3_9_005_*`; H-NEW-ATTACHMENT-008 | `src/cli/issue/attachments.rs::handle_attachment_upload_jsm` | Step 4.5 STRICT; P23-002 EC-3.9.005-3 |
| BC-3.9.006 | Step-2 `post_request_attachment` error taxonomy: 401/403/4xx/5xx/network; 429 DELIBERATELY falls into generic 4xx (EC-3.9.006-7 deliberate asymmetry: step-2 is trivially-rebuildable JSON POST, blast radius low; ADR-0017 multipart constraint does NOT apply); `Retry-After` NOT parsed | — | `tests/attachment_jsm.rs::test_bc_3_9_006_jsm_upload_error_taxonomy` | `src/api/jsm/attachments.rs::post_request_attachment` | F5-R8-001 deliberate-asymmetry ruling; spec v1.3.105; Step-7 secondary review L3 dissent RECORDED (STEP2-429-RETRY enhancement candidate ledgered); EC-3.9.006-7 trip-wire pin PR #651 |
| BC-3.9.007 (EC-3.9.007-2 JSM) | JSM upload echo: `curate_jsm_attachment_entry` from `AttachmentCreateResultDTO.attachments.values[]`; defensive field-by-field curation; EC-3.9.011-3 no `"public"` key in output | — | `tests/attachment_jsm.rs::test_bc_3_9_007_*`; E2E `test_e2e_jsm_attachment_public_echo_shape` (S-576-6 live) | `src/api/jsm/attachments.rs::attach_temporary_file` (extract → step-2 delegates); `src/cli/issue/attachments.rs::handle_attachment_upload_jsm` | P2-3c DISCHARGED; BC-3.9.007/011 MEDIUM→HIGH Confidence (probe run 29945857059 SUCCESS) |
| BC-3.9.011 | `--public/--internal --output json` shape: bare curated array `[{author,contentUrl,created,filename,id,mimeType,size}]`; EC-3.9.011-1 confirmed schema; EC-3.9.011-3 no `"public"` key | — | `tests/attachment_jsm.rs::test_bc_3_9_011_*`; E2E live pin (S-576-6) | `src/cli/issue/attachments.rs::handle_attachment_upload_jsm`; `output::render_json` | Step 4.5 STRICT; probe runs confirmed; F6 D1 VP check |
| BC-3.9.012 (JSM branch) | JSM upload error taxonomy: step-1 `attachTemporaryFile` 403/404 carve-out → BC-X.8.010 self-heal first; post-retry 404→exit 64, 403→exit 1; P30-001/P31-003 | — | `tests/attachment_jsm.rs::test_bc_3_9_012_*` | `src/cli/issue/attachments.rs::handle_attachment_upload_jsm`; `src/api/jsm/attachments.rs::attach_temporary_file` | Step 4.5 STRICT; SEC-576-006 stale-ID heal |
| BC-X.8.010 | JSM serviceDeskId resolution via `get_or_fetch_project_meta` + `ProjectMeta` cache; `serviceDesk.projectId == project.id`; stale-ID self-heal invalidate+retry-once; `stale_healed` guard is per-command NOT per-file (WAVE-576-05 DOCUMENT-AS-IS); EC-X.8.010-1 no-match exit 64; EC-X.8.010-2 multi-file second independent failure after heal fires → raw exit 1 (near-unreachable) | — | `tests/attachment_jsm.rs::test_bc_x_8_010_*`; `tests/attachment_jsm.rs::test_bc_3_9_003_stale_heal_*` | `src/api/jsm/servicedesks.rs::get_or_fetch_project_meta`; `src/cache.rs` (`ProjectMeta`); `src/api/jsm/attachments.rs` (`stale_healed: bool`) | F5-R12-001 WAVE-576-05 DOCUMENT-AS-IS ruling; spec v1.3.106; EC-X.8.010-2 added; BC-INDEX v6.44 |

---

## S-576-6: Live-Jira E2E Coverage (PR #643 @ 9da03d5b, 2026-07-23)

| Coverage surface | VP | Test | Src symbol | Review evidence |
|-----------------|-----|------|-----------|----------------|
| Platform round-trip: list → upload → download → delete | — | `tests/e2e_live.rs::test_e2e_attachment_platform_roundtrip` (gated `JR_RUN_E2E=1`) | All attachment src files | CI 15/15; live run 30041659024 97/97 GREEN (post FIX-576-DL rebase) |
| JSM `--public`/`--internal` two-step; echo shape pin (BC-3.9.011) | VP-576-005 (live assertion) | `test_e2e_jsm_attachment_upload_public`; `test_e2e_jsm_attachment_upload_internal`; `test_e2e_jsm_attachment_public_echo_shape`; `test_e2e_jsm_attachment_internal_echo_shape`; `test_e2e_jsm_attachment_upload_no_flag` (gated `JR_E2E_JSM_PROJECT=EJ`) | `src/cli/issue/attachments.rs::handle_attachment_upload_jsm` | Step 4.5 STRICT (8 passes / 5 fix rounds; p6/p7/p8 CLEAN×3); SEC-S576-6-001 accepted (CWE-703 Drop expect MEDIUM); fresh-eyes APPROVE 0 C/H |
| `AttachmentDropGuard` unwind-safe AID teardown | — | AC-002 `Drop` impl in `tests/e2e_live.rs` | `tests/e2e_live.rs::AttachmentDropGuard` (tests only) | Step 4.5 STRICT; SEC-S576-6-001 tech debt |

---

## Story-level depends_on cross-references

| Depends | On | Mechanic | Evidence |
|---------|----|----------|---------|
| S-576-5 | S-576-3 | BC-X.8.010 stale-ID gate reuses `delete_attachment` from upload path; JSM upload confirms replacement ordering with VP-576-003 S3 machinery | sprint-state.yaml `depends_on: [S-576-3, S-576-4]` |
| S-576-5 | S-576-4 | BC-3.9.017 step-4 skip-Step-0 path (`--replace-existing --internal`) uses delete machinery from S4 | sprint-state.yaml `depends_on: [S-576-3, S-576-4]` |
| VP-576-004 upload | S-576-1 | Curated-serialization plumbing (`display_sanitize_filename`, BTreeMap ordering) earliest-consumer principle (R3.13) | P24-002 story-allocation annotation; S1 ships the plumbing, S3 consumes it |
| VP-576-005 | S-576-3 | Combined `--replace-existing --public` single-prompt gate requires S3 `--replace-existing` gate mechanics | P23-003; BC-3.9.017 textual home |

---

## F5 adversarial rounds that modified BCs in this delta

| Spec version | Round | BCs touched | Nature |
|---|---|---|---|
| v1.3.95 | F5 pass-1 (Step 4.5 S1) | BC-2.7.002 | author-curated-form ruling (P1-002): removed internal contradiction on pass-through vs curated |
| v1.3.96 | F5 pass-2 (Step 4.5 S1) | BC-2.7.001 | EC-2.7.001-3 empty-string fallback ratification (P2-001) |
| v1.3.97 | F5 pass-8 (Step 4.5 S2) | BC-2.7.007 | EC-2.7.007-5 SIGINT cleanup note corrected: `exit(130)` direct, no temp-file registry |
| v1.3.99 | P2-3c probe DISCHARGED | BC-3.9.007, BC-3.9.011 | Confidence MEDIUM→HIGH; servicedeskapi schema confirmed |
| v1.3.102 | F5-R5-001 | BC-2.7.012 | HYBRID disk-error strings: `classify_write_error` fn mandate; `StorageFull\|QuotaExceeded`, `PermissionDenied\|ReadOnlyFilesystem`, generic fallback |
| v1.3.103 | FIX-F5-010 | BC-2.7.012 | Windows P9-001: `(writing <dest>)` parenthetical in permission-denied row |
| v1.3.104 | F5-R6-001/002 | BC-2.7.012 | io-site count 3→4 (add `flush`); mid-stream abort INFO note |
| v1.3.105 | F5-R8-001/P8-001 | BC-3.9.006 | EC-3.9.006-7 429 deliberate-asymmetry sub-case; Retry-After carve-out explicitly deferred |
| v1.3.106 | WAVE-576-05/F5-R12-001 | BC-X.8.010 | EC-X.8.010-2 added; `stale_healed` per-command DOCUMENT-AS-IS ruling |
