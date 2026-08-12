## Fresh-eyes PR review — PR #681 (S-639-1)

**VERDICT: APPROVE** · Covered SHA: `4bfa0c21`

Independent PR-diff review (a different lens from the 5 prior adversarial passes). All 14 changed files reviewed. **No BLOCKING / WARNING / NIT findings.**

> Posted to GitHub as a review in **COMMENT** state, not APPROVE — the reviewing identity equals the PR author, so GitHub rejects a formal `--approve` from the author. The APPROVE verdict above is authoritative.

### Checklist results

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — every change relates to the pre-flight guard (src, tests, ADR, CHANGELOG, version, help, CLAUDE.md). No unrelated changes. |
| 2 | Description accuracy | PASS — PR body matches the diff; migration + verbatim error strings accurate. |
| 3 | Test coverage | PASS — changed lines covered; non-vacuous, discriminating assertions. |
| 4 | Demo evidence | PASS — PR documents 4 VHS clips (GIF+WebM) for the 4 primary ACs + positive control. |
| 5 | Commit quality | PASS — Conventional Commits, story ID present. |
| 6 | Diff size | NOTE — 1,636 insertions, but ~1,441 are test additions in one file; src delta is ~40 lines. Reasonable for a breaking-change guard with 21 ACs. |
| 7 | Missing changes | PASS — all 21 ACs implemented and test-backed; AC-11 regression pin restored. |
| 8 | Dependency status | PASS — no upstream PR deps. |

### Guard correctness — `src/cli/issue/create.rs::handle_create`
- **Placement:** guard sits immediately after the `if request_type.is_some()` JSM dispatch fork and BEFORE project-key resolution, interactive prompts, the blocking `--description-stdin` read, and any HTTP call. JSM path provably untouched (returns into `handle_jsm_create` before the guard is reachable).
- **Ordering:** combined check (`!field_pairs.is_empty() && on_behalf_of.is_some()`) fires first → one error; single-flag checks follow. Presence-only → empty/malformed/repeated values still trip exactly one error.
- **Exit code:** `JrError::UserError` → 64. In-code comment correctly documents why `#[arg(requires=...)]` (clap exit 2) was deliberately NOT used.
- **Error strings:** byte-for-byte identical to the story oracle for `--field`, `--on-behalf-of`, and combined cases.

### Test quality — `tests/issue_create_jsm.rs`
- Zero-HTTP proof is normative: `server.received_requests().is_empty()` + `expect(0)` mocks on isolated `MockServer` (AC-8); "no `Project key` error" assertions prove the guard precedes project resolution (AC-9/11).
- Positive controls genuinely exercise the JSM path: mount `/rest/servicedeskapi/request` with `expect(1)`, assert exit 0 — the POST actually fires (`..._does_not_fire_bc_3_8_012`, `..._does_not_fire_guards`).
- AC-11 regression pin present: `!stderr.contains("is ignored on the platform create path")`, with the test honestly documenting its non-discriminating aspects.
- No stale test asserts the old warn-and-proceed behavior; the old string appears only in 16 negative regression pins.
- `assert_json_error_envelope` cleanly promoted to `tests/common/assertions.rs`; `write_profile_config` fixture avoids migration-line stderr poisoning for strict JSON parsing.

### Breaking-change hygiene
- `Cargo.toml` bumped `0.6.0-dev.11 → 0.6.0-dev.12`.
- `CHANGELOG.md` `### Breaking Changes` entry with migration + JSON-envelope note.
- ADR-0014 amended in all four "byte-for-byte unchanged" claim sites.
- Help text on both flags updated to say "requires --request-type" (AC-12 pins count == 2).
- CLAUDE.md dispatch-fork gotcha amended + new S-639-1 entry.

### CI
All real jobs green (Test ×3 OS, Clippy ×2, MSRV, Coverage, Deny, Spec Guards, Format, Signing guard). Red `Secret Scan (gitleaks)` is a transient binary-download error ("socket hang up"), not a code finding — re-run pending. Mutation testing still in progress at review time (non-blocking).

### Findings
None blocking. The change is additive guards + doc/string updates with no behavioral change to the clean platform path (AC-4 regression baseline preserved).
