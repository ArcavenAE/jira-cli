# S-288-pr4-dispatch Adversary Pass 06

## Verdict
FINDINGS — counter resets to 0/3.

## Findings

### CRITICAL / HIGH
None.

### MEDIUM

**F-M-01: L-288-pr2-02 recurrence — `||` accept-either at ADF key check**
- File: `tests/issue_create_jsm.rs:731`
- ```rust
  assert!(
      desc_obj.get("type").is_some() || desc_obj.get("content").is_some(),
      "BC-3.8.006: ADF root must have 'type' or 'content' key; got: {desc_obj}"
  );
  ```
- ADF root nodes (per `src/adf.rs::text_to_adf` and `markdown_to_adf`) emit `{"type":"doc","version":1,"content":[...]}` — BOTH keys are always present. The `||` permits silent ADF-shape drift.
- **Fix**: test-writer splits into two strict assertions: `assert_eq!(type, "doc")` + `assert!(content.is_array())`.

### LOW / NIT
- **O-01 (pending intent)**: AC-011 says warnings fire "ONLY on the success path" but impl fires them BEFORE dispatch. BC-3.8.010 uses permissive "need not fire" wording — impl is BC-compliant. The drift is in the story's AC text being over-narrow vs the BC. Cheap fix: PO loosens AC-011 wording to match BC. Or move warnings post-validation in impl. Adversary marked "Not blocking."

### DEFERRED (acknowledged, not reflagged)
- M-03 (pass-03): InsufficientScope Display stale text — DEFERRED.
- O-01 (pass-05): platform-path inverse silent-drop of `--field`/`--on-behalf-of` — DEFERRED.

### Process-gap findings
None.

## Cross-axis verification (all PASS except F-M-01)
- L-288-pr2-02 grep on `||` accept-either: **1 hit** at tests/issue_create_jsm.rs:731 (F-M-01)
- L-288-pr2-02 grep on `.or_else(`: 7 hits, all `Option<String>` chain fallbacks (NOT JSON accept-either) — not findings
- POLICY multi-profile-cache (CRITICAL): correct
- Platform-path regression: pinned by `test_jsm_create_without_request_type_uses_platform_path` (expect(0) servicedeskapi + expect(1) platform)
- POLICY zero-clippy + refactor-not-suppress: 0 `#[allow]`
- AC-016 OAuth scope pin: present + lockstep
- AC-018 mutation scope: all 3 new files in .cargo/mutants.toml
- BC-3.8.011 verbatim wording: 5 stderr pins match BC character-for-character

## Reviewed surfaces
- Full read: src/cli/issue/create.rs (handle_create + JSM helpers + proptests), src/api/jsm/requests.rs (full + proptests), src/api/auth.rs (DEFAULT_OAUTH_SCOPES), src/cli/auth/tests/mod.rs (scope pin), src/cli/mod.rs (clap), src/cli/issue/mod.rs, src/api/client.rs (401 dispatch), src/api/jsm/servicedesks.rs, src/cache.rs (request_type cache), src/error.rs, tests/issue_create_jsm.rs (all 29 tests)
- Spec/story: story.md (19 ACs), bc-3-issue-write.md (BC-3.3.001, BC-3.8.001..011)
- Configs: CLAUDE.md, CHANGELOG.md, .cargo/mutants.toml, docs/specs/cargo-mutants-policy.md

## Not reviewed (out of perimeter)
- pr1-api / pr2-cli (merged)
- Regression baseline tests/* (assumed green per BC-3.3.001)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| F-M-01 | MEDIUM | test-writer | Split `||` at line 731 into 2 strict asserts |
| O-01 | LOW | product-owner | Loosen AC-011 wording to match BC-3.8.010 permissive "need not" |
| Deferred items | — | — | Unchanged |

Sequencing: PO + test-writer in parallel; re-dispatch adversary pass-07.

## Novelty Assessment
**LOW-MEDIUM** — F-M-01 is a single-line test-precision fix; O-01 is cosmetic AC-text drift. Story is converging; pass-07 likely CLEAN after these tight fixes.
