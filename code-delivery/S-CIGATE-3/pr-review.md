## PR Review — S-CIGATE-3 (PR #680)

**Verdict: REQUEST_CHANGES** — 1 blocking finding (5 verified instances), 4 suggestions, 4 nits.

> ⚠️ **Submitted as a COMMENT-state review, not a formal `CHANGES_REQUESTED` review.** GitHub rejects `gh pr review --request-changes` on a self-authored PR (`Review Can not request changes on your own pull request`). The verdict below is nonetheless **REQUEST_CHANGES** and should be treated as blocking: do not merge until B-1 is resolved.

This is a high-quality refactor and the core of it genuinely works. I verified that by attacking it rather than reading it: **26 hand-crafted hostile `ci.yml` mutations**, each applied to a temporary swap of the tracked file and restored byte-identically afterward (`git diff --quiet .github/workflows/ci.yml` confirmed clean after every round). 23 of 26 were caught loudly, including both round-16 node-property forms the story exists to close. Where a claim of mine depends on "did the old code catch this?", I ran the same mutation against a throwaway `origin/develop` worktree to establish regression-vs-pre-existing rather than assuming.

The blocking finding is narrow and mechanical: the migration closed the node-property class on the **key** side and simultaneously opened it on the **value** side, in a way the pre-PR byte comparison caught. That directly contradicts AC-004, which this PR's body reports as `Done — no pin deleted or weakened`.

### Verification performed (live, this review)

| Check | Result |
|---|---|
| `cargo test --test ci_gate_completeness` | 58 passed / 0 failed (32 guard + 26 `wf.rs`) |
| `cargo test` (full suite) | all binaries ok, 0 failures, exit 0 |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo deny check` | `advisories ok, bans ok, licenses ok, sources ok` (only pre-existing unmatched-allowance warnings) |
| `cargo clippy --target x86_64-pc-windows-msvc --tests` | no Rust-level lint error before the unrelated `aws-lc-sys` C-toolchain failure |
| Sibling consumers (`ci_yml_windows_matrix`, `backfill_matrix_parity`) | 37 + 34 passed; zero `pub fn` removed from `tests/common/yaml.rs` |

**AC spot-checks that hold.** AC-001 exact pin `saphyr-parser = "=0.0.11"` present. AC-002 zero `saphyr::Yaml` / `saphyr::YamlLoader` constructions — the only two matches in the changed files are inside `wf.rs`'s module doc explaining why the API is forbidden. AC-005 `test_ci_yml_contains_no_non_lf_yaml_line_breaks` is present, unconditional (no `#[cfg]`, no `#[ignore]`), reads the **raw** file via `fs::read_to_string` with no normalization, and covers every sibling workflow — genuinely an independent third layer. AC-008's persisted proof is hygienically clean: every fixture is an in-memory `format!` string; there is no `fs::write`/`File::create`/`tempfile` anywhere in the three changed files, and `ci.yml` is byte-identical to `develop` in this diff. No `#[test]` fn was deleted — the only removals are the line-based helpers (`extract_key_name_at_indent`, `collect_mapping_key_set`, `find_comment_start`, `line_declares_job_level_key`, `assert_job_block_uses_4_space_child_indent`, `extract_test_guard_step_lines`), all confirmed to have zero remaining callers. Every pre-existing `PINNED_*` constant is retained byte-identically, five new ones added. Both count tripwires are accurate (32/32, 26/26). All 22 commits are Conventional Commits with the story ID.

**Attacks caught (sample).** `&x shell: cat {0}` and `!!str shell: cat {0}` on the gate step (the round-16 pair); `&x run:` — an anchor on an *already-legitimate* key, which key-set comparison alone can never catch and which `find_key_node_properties` catches specifically; `|| true`; `continue-on-error: true`; step- and workflow-level `shell: cat {0}`; a smuggled `BASH_ENV:` sibling; workflow-level `defaults:`; a second `---` document; a duplicate `ci-gate:` job; a re-quoted `if: "${{ always() }}"`; `if: ${{ always() && false }}`; a flow-style gate step; a flow-style `jobs:` mapping; `*alias` as the run value; a shrunken `needs:` list; an empty `run:`; `continue-on-error`/`if: false` on `test`/`msrv`/`fmt`; `shell: cat {0}` on an `msrv` step; `--self-test || true` in `spec-guard`; `-D warnings` → `-W warnings` in `clippy`; a decoy `- run:` step ahead of the gate step; tab indentation. The `find_key_node_properties` recursion genuinely walks every level (job keys → `steps:` items → step keys → the gate step's `env:` children), not one.

---

## BLOCKING

### B-1 — Node properties on the VALUE side are now invisible; `develop` rejected them loudly (AC-004 violated)

`tests/common/wf.rs::resolve_value` destructures `Event::Scalar(text, style, _anchor_id, tag)` and **discards `anchor_id`**. `Value::Scalar` therefore carries `text`, `style`, and `tag` but has no `has_anchor` field, so every byte pin built on it asserts `ScalarStyle::Plain` and rejects a `tag`, but silently accepts an anchor. Separately, `job_level_value_span` slices raw source from the `SequenceStart` event's span, which `saphyr-parser` starts at the `[` — *after* any node property — so a tag or anchor on the `needs:` flow sequence is sliced away before comparison.

Five instances, each verified by running the full suite against a temporarily-mutated `ci.yml` on this branch **and** on `origin/develop`:

| Mutation to `ci.yml` | This PR | `origin/develop` |
|---|---|---|
| `run: &x echo "${NEEDS_JSON}" \| bash scripts/check-ci-gate.sh` | **58/58 pass** | FAILED (1) |
| `if: &a ${{ always() }}` | **58/58 pass** | FAILED (1) |
| `NEEDS_JSON: &z ${{ toJSON(needs) }}` | **58/58 pass** | (same mechanism) |
| `needs: !!seq [fmt, clippy, …]` | **58/58 pass** | FAILED (10) |
| `needs: &n [fmt, clippy, …]` | **58/58 pass** | FAILED (10) |

This is the same category of quiet loosening the story already recognised and fixed once. `CLAUDE.md`'s own S-CIGATE-3 record states it explicitly for the quoting case: *"Without this style check, the migration would have quietly accepted re-quoted forms the old checker rejected — a real, if easy to miss, loosening."* The identical reasoning applies verbatim to anchors, and the `ScalarStyle::Plain` guard was added for precisely this reason — the anchor half was missed.

I am not claiming an end-to-end exploit from an anchor alone: `&n` is semantically inert, and an `*alias` in a value position is correctly rejected as `Value::Alias` (I confirmed that attack fails). The reason this blocks is narrower and, I think, harder to argue with:

1. **AC-004 says "not weakened", and the PR body reports it `Done — no pin deleted or weakened`.** Five pins are verifiably weaker than on `develop`. The AC as written is not met.
2. **It is a blind spot in the exact class the story exists to close.** A reader of `CLAUDE.md`'s new SCOPE SUMMARY — which now moves node properties from "NOT enforced" to "Enforced" — would reasonably conclude anchors are handled. On the value side they are not, and nothing in the summary says so.
3. **GitHub shipped anchors/aliases to production Actions on 2025-09-18**, which is the premise of round 16. An anchor is the half of an anchor/alias pair that this checker no longer sees.
4. **The fix is small.** Add `has_anchor: bool` to `Value::Scalar` from the `anchor_id` already in hand (non-zero ⇒ anchored) and assert it false in the four scalar extractors, mirroring the existing `tag.is_some()` branches; for `needs:`, either extend `job_level_value_span`'s start bound back over any node property or reject a non-`None` tag / non-zero anchor on the sequence node.

**Scope note so this is not over-claimed:** `env: !!map` (a node property on a *collection* value) also passes here — but it passes on `develop` too, so that one is a **pre-existing** gap, not a regression, and I am not asking for it in this PR. Only the five rows above are regressions.

---

## SUGGESTIONS

### S-1 — `find_key_node_properties` returns `Vec::new()` when the input has no top-level mapping, so its absence-shaped assertion can pass vacuously

`find_key_node_properties` early-returns `Vec::new()` on no `Event::MappingStart`; M2-q's only assertion is `assert!(node_properties.is_empty(), …)`. An extractor that returns empty for a *non-clean* reason under an absence-shaped assertion is exactly the failure mode `CLAUDE.md` records as the corrected round-12/13 rule ("any check whose EXTRACTOR can silently under-report its input fails open… the assertion is only as strong as the extraction feeding it").

Today this is protected only by *incidental caller ordering* — `test_ci_gate_pass_fail_semantics_are_structurally_placed` happens to call `WfDoc::parse_single_job(gate_block)` earlier in the same fn, which panics on that input. Nothing in `find_key_node_properties` or in M2-q enforces that ordering. I could **not** reach it from a mutated `ci.yml` (my flow-style `jobs:` attempt failed loudly, 26 tests), so this is latent robustness, not a live vacuous pass — which is why it is a suggestion and not blocking. `WfDoc::parse_single_job` already has the right shape: panic with "job_block has no top-level mapping at all". Mirroring that here makes the guarantee structural rather than positional.

### S-2 — Five accessors select the job root with `.first()`, contradicting `find_unique_entry`'s documented contract

`job_level_value_span`, `step_mapping_child_keys`, `step_mapping_child_keys_by_step_name`, `step_mapping_child_value`, and `job_body_entries` each take `root_entries.first()` with no arity check, while `WfDoc::parse_single_job` panics on ≠1 root entry. `find_unique_entry`'s doc comment claims every mapping-child lookup in the module was converted away from silent-first-match; that is true for *named-key* lookups but not for the *root-entry* selection those lookups start from — the one that decides which job gets examined at all. `extract_gate_env_key_set` and `extract_and_normalize_sole_needs_json_line` reach `step_mapping_child_keys` without a prior `parse_single_job`, so they sit outside that panic. Either give these the same "exactly one root entry" assertion, or narrow the doc comment's claim.

### S-3 — `CLAUDE.md`'s S-CIGATE-3 record has three inaccuracies

The in-code comment at the M2-q assertion is admirably precise about the value-side residual ("A node property on a pinned scalar's VALUE instead (`run: &x cargo check …`) is a DIFFERENT construct this assertion does not scan for"). `CLAUDE.md`'s SCOPE SUMMARY — the file this repo treats as the canonical scope record, and which has been corrected for this exact class of overstatement in passes 54/55 — does not carry that caveat. It lists only the "jobs other than `ci-gate`" residual. Also:

- *"as of `130c634f`, the last commit in the story"* — six commits followed it (`aeeebe01`, `99f53383`, `dfc69662`, `bc86d4ce`, `d32f9f67`, `73a117cb`), and the same paragraph then describes `73a117cb`'s test, so it contradicts itself.
- *"grown to ~2,483 LOC by `130c634f`"* — the file is now 2,759 lines.
- `bc86d4ce` is a real behavioural fix (last-job span bounded to the next root key rather than EOF) and is documented in `Job::span`'s rustdoc but not in the `CLAUDE.md` fix-burst list.

### S-4 — Stale panic text in the retained non-LF line-break scan

The doc comment above `test_ci_yml_contains_no_non_lf_yaml_line_breaks` correctly explains the post-refactor retention reason (YAML 1.2 does not treat NEL/LS/PS as line breaks, so the parser subsumes only lone CR). The `panic!` body still asserts the old premise: *"Every line-based extractor in this suite splits on `str::lines()`"* and *"a real YAML-parse rewrite is the durable fix, tracked as a follow-up story, not this test."* Both are now false — this PR *is* that rewrite. A reader hitting this failure gets a misleading diagnosis of a test that is still correct and still load-bearing.

---

## NITS

**N-1.** `wf.rs`'s 26 unit tests compile and execute in **all 59** integration-test binaries that declare `mod common;` (I confirmed 26 `common::wf::tests::*` running inside `--test board_commands`), so `cargo test` runs them ~1,534 times. The authors documented this and gave a sound rationale (private items like `read_mapping`/`char_byte_table` are only reachable from a nested `#[cfg(test)] mod tests`). They are fast, so the cost is small — noting it as a known-cost follow-up, not a defect.

**N-2.** Both count tripwires do `source.lines().filter(|l| l.trim().starts_with("#[test]")).count()`. Correctly immune to `///`/`//` mentions (83 textual occurrences vs 32 counted). But because the comparison is `assert_eq!`, a compensating edit — delete one real `#[test] fn` and add one decoy line inside a raw string or `/* … */` block — keeps it green; neither assertion validates that a counted `#[test]` is followed by an `fn`.

**N-3.** Several loud-panic paths in `wf.rs` are untested: the `Job::value_of`/`Step::value_of` duplicate-key asserts added by fix-burst-8 have no `should_panic` test, and `step_mapping_child_keys_by_step_name`'s `0`- and `n`-match `Err` arms — the entire point of that function — are uncovered. The coverage that *is* present is genuinely non-tautological (the multi-byte span round-trip would catch a byte/char regression in `Marker::index()`; both last-job-span directions are pinned).

**N-4.** Informational — the documented residual is accurate. I confirmed that an anchor on an already-legitimate key in a **non**-`ci-gate` job (`&x name:` on an `msrv` step) passes, exactly as `CLAUDE.md` says it will. A *new* anchored key in those jobs is still caught by their key-set pins (verified). Also confirmed the round-15 Windows dead-code class is avoided: all six previously-gated items remain `#[cfg(unix)]`, `wf.rs` has no platform-gated code, and every `mod common;` declaration carries `#[allow(dead_code)]`.

---

## Checklist

| Item | Result |
|---|---|
| Diff coherence | Pass — test infra + dev-dep + docs only; zero `src/` changes |
| Description accuracy | **Fails on AC-004** ("no pin weakened" — see B-1); accurate and commendably candid elsewhere, incl. the first-CI-run and Windows-clippy callouts |
| Test coverage | Pass — 58/58, full suite green; gaps noted in N-3 |
| Demo evidence | N/A — no product BCs, no user-visible behaviour |
| Commit quality | Pass — 22/22 Conventional Commits with story ID |
| Diff size | Large (6,140+/2,173−) but justified for a whole-file extraction-layer replacement; `wf.rs` growth is guards + their tests |
| Missing changes | Pass, except B-1 |
| Dependency status | Pass — S-CIGATE-2 (`df203233`) on `develop` |

**What I would need to flip to APPROVE:** B-1 closed (capture and reject the value-side anchor on the four scalar pins, plus tag/anchor rejection on the `needs:` sequence node), with a RED proof against a temporary `ci.yml` copy for at least the `run: &x …` and `needs: &n […]` forms. S-1 through S-4 are worth doing in the same pass but I would not hold the PR for them alone.


---

# REVIEW CYCLE 2 (fix commit dc4909b2)

## PR Review — S-CIGATE-3 (PR #680), REVIEW CYCLE 2

**Verdict: APPROVE.** The cycle-1 BLOCKING finding B-1 is resolved. I verified this by re-running B-1's own attacks against the tracked `.github/workflows/ci.yml` (mutate → test → confirm loud failure → restore byte-identically), by RED-proving the six new tests against the pre-fix code, and by probing the fix for false positives. Every temporary mutation was restored; `git status --short` is empty and `ci.yml`/`wf.rs`/`ci_gate_completeness.rs` are all byte-identical to HEAD after each experiment.

`covered_sha: dc4909b2370284e5c88d517679f391fb2ec59c1f`

---

### (a) Is B-1 actually resolved? — YES, verified live

Fix mechanism (dc4909b2): `Value::Scalar` gains `has_anchor: bool` captured from `anchor_id != 0` in `resolve_value` (previously discarded via `_anchor_id`); `job_level_value_span` now returns a `ValueSpanOutcome` enum, emitting `NodeProperty { has_anchor, tag }` (instead of a slice-able span) when the composite value node's own `MappingStart`/`SequenceStart` carries an anchor or tag; all four scalar pins add an `if *has_anchor { Err }` branch mirroring their existing `tag.is_some()` branch, and the `needs:` pin gains both an anchor check and its first-ever tag check.

I reproduced all five of B-1's original constructions against the tracked `ci.yml`. Each is now caught **loudly**, citing the B-1 rejection:

| Mutation to `ci.yml` | Result (post-fix) | Pin / message |
|---|---|---|
| `run: &x echo "${NEEDS_JSON}" \| bash …` | FAILED (1) | M2-i — "`run:` value carrying a YAML anchor (`&...`) — S-CIGATE-3 B-1 fix" |
| `if: &a ${{ always() }}` | FAILED (1) | M2-m — "`ci-gate`'s own job-level `if:` … carrying a YAML anchor" |
| `NEEDS_JSON: &z ${{ toJSON(needs) }}` | FAILED (1) | M2-n — "`NEEDS_JSON:` env-child line … carrying a YAML anchor" |
| `needs: &n [fmt, clippy, …]` | FAILED (1) | M2-p — "value node (anchor=**true**, tag=None)" |
| `needs: !!seq [fmt, clippy, …]` | FAILED (1) | M2-p — "value node (anchor=false, tag=**Some("tag:yaml.org,2002:seq")**)" |

On the specifically-flagged **`needs:` tag case**: cycle 1 noted this "already failed differently" on `develop` (via a downstream count mismatch). It is now caught by the *new* mechanism — `job_level_value_span` returns `ValueSpanOutcome::NodeProperty`, and `extract_and_normalize_sole_needs_line` rejects it, printing the actual resolved tag `tag:yaml.org,2002:seq`. This is the dedicated B-1 rejection path, not a coincidental catch.

### RED-proof of the six new tests — GENUINE

I reconstructed a faithful pre-fix tree: parent `73a117cb`'s `wf.rs` + `ci_gate_completeness.rs`, then appended only the six new `test_b1_*` fns and bumped the const. Result: **0 passed / 6 failed** — every new test fails against the pre-fix pin logic. They also *compiled* against the pre-fix `wf.rs` (which has no `has_anchor` field), confirming they exercise only the pin functions, not the new field directly. This is a real RED proof, not a tautology.

### (b) Regression / weakening / false positives — NONE found

- Full suite green post-fix: `cargo test --test ci_gate_completeness` → **64 passed / 0 failed** (32 prior guard + 6 new = 38 guard, + 26 `wf.rs`). `cargo fmt --all --check` clean; `cargo clippy --test ci_gate_completeness -- -D warnings` clean.
- **False-positive probe (empirical, not just reasoning):** I temporarily added a probe to `wf.rs`'s test module and confirmed `has_anchor`/`NodeProperty` are driven purely by the parser's `anchor_id != 0` / `tag`, never by text scanning. A `&&` inside `${{ always() && github.ref == 'refs/heads/foo&bar' }}` and a `foo&bar` inside a quoted string both resolve with `has_anchor == false`; a genuine `&realanchor` resolves `true`; a plain `needs: [fmt, clippy]` still returns `ValueSpanOutcome::Span`. So there is **no false-positive surface** from `&`-in-text — the concern raised in the review brief does not materialize. Every one of the six new tests also carries a passing positive control, so none of the pins became unconditionally rejecting.

### (c) AC-004 ("no pin deleted or weakened") — NOW SATISFIED

All five rows cycle 1 showed as weaker-than-`develop` are closed. The value side is now at least as strong as `develop` for the anchor case, and *stronger* for the `needs:` tag/anchor case (caught by a dedicated, self-describing pin rather than a downstream side effect). No pre-existing pin was deleted or loosened; the change is purely additive rejection plus one enum widening on the `needs:` composite path.

### Count tripwire (cycle-1 N-2) — accurate, mechanism unchanged

`EXPECTED_GUARD_TEST_COUNT = 38` matches reality: 38 lines trim-start with `#[test]`, each followed by an `fn`, and `test_this_file_test_count_matches_expected_denominator` passes. N-2's standing observation (an `assert_eq!` count is satisfiable by a compensating decoy edit) is unchanged — neither improved nor worsened by this commit; it remains a non-blocking nit.

### Scope & incidental effects on S-1..S-4 / N-1..N-4

The fix commit touches only `tests/ci_gate_completeness.rs` and `tests/common/wf.rs` — no `src/` changes (whole PR: test-infra + docs only). None of the prior suggestions/nits regressed:

- **S-1** (`find_key_node_properties` vacuous-empty return) — untouched, still latent-only.
- **S-2** (`.first()` root selection) — `job_level_value_span` was modified but still routes through `find_unique_entry`; the root-selection concern is unchanged, not worsened.
- **S-3** (value-side residual not caveated) — *improved*: `find_key_node_properties`'s doc comment now states the value-side gap is "now CLOSED … for the five pins that need it." Note the `CLAUDE.md` SCOPE SUMMARY itself was not updated in this commit, so S-3's `CLAUDE.md`-specific inaccuracies (the `130c634f` "last commit" claim, LOC figure) still stand — non-blocking, worth a follow-up doc pass.
- **S-4** (stale panic text in the non-LF line-break scan) — untouched, still stale, still non-blocking.

---

### What I ran

| Check | Result |
|---|---|
| 5× B-1 mutations vs tracked `ci.yml` (mutate→test→restore) | all 5 caught loudly with B-1 message; `ci.yml` restored byte-identical each time |
| 6 new tests vs pre-fix (`73a117cb`) tree | 0 passed / 6 failed — genuine RED |
| False-positive probe (`&&`, `foo&bar`, genuine `&anchor`, plain flow seq) | correct in all four cases |
| `cargo test --test ci_gate_completeness` | 64 passed / 0 failed |
| `cargo fmt --all --check` / `cargo clippy --test … -D warnings` | clean / clean |
| `git status --short` after all experiments | empty (worktree clean) |

No blocking findings. Approving. The remaining open items (S-1/S-2/S-4 latent-robustness, S-3's `CLAUDE.md` doc drift, N-2's count-tripwire) are all pre-existing, non-blocking, and unchanged-or-improved by this commit — fine to address in a follow-up rather than holding the PR.

---

# CYCLE 2 — FINAL VERDICT (independent re-review): APPROVE

**Covered SHA:** `dc4909b2370284e5c88d517679f391fb2ec59c1f`
**B-1: RESOLVED — independently verified (RED-proof reproduced by neutering only the fix → 6/6 fail; restored → 64/64 pass).**

Full cycle-2 analysis: `pr-review-cycle2.md` (this directory).

Summary: value-side node properties now rejected on all 5 pins (`if:`, `run:` ×2, `NEEDS_JSON:`, `needs:`); `needs:` gains both anchor and its first tag check. Purely additive — no existing pin deleted or weakened → **AC-004 satisfied**. No false positive on the real `ci.yml` (plain flow-seq `needs:`, plain `if: ${{ always() }}`); `has_anchor` is parser-driven, not text. fmt/clippy clean; PR mergeState CLEAN; all 15 checks + CI Gate SUCCESS.

**GitHub review posting note:** `gh pr review --approve --body-file` was attempted via github-ops but GitHub rejects approving a self-authored PR ("Can not approve your own pull request"); the verdict was therefore posted via `gh pr review --comment --body-file` (a formal review, NOT `gh pr comment`). Verdict is **APPROVE**. Do not merge on the reviewer's behalf.
