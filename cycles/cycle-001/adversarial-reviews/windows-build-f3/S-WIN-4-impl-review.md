# S-WIN-4 Implementation — Step 4.5 Per-Story Adversarial Convergence (BC-5.39.001)

Date: 2026-06-13. Branch feat/win-4-release-yml-windows off develop 219debc. Commits: 3fbb84d (release.yml: windows-msvc matrix row, Package(Windows) pwsh Compress-Archive, Checksum(Windows) bash sha256sum, smoke-step gated off Windows, shell:bash on build steps, jr-*.zip globs + 5 presence tests), ebc5475 (F-WIN4-IMPL-101: anchor AC-003 smoke-gate test), 2150355 (F-001/F-002: anchor AC-004/AC-005/AC-002 to step blocks), 3a4cdf0 (F-1/F-2: step_block helper — windows slice to next - name: boundary, robust).
Change: release.yml Windows release artifact via PowerShell Compress-Archive (ADR-0016 Decision 2 / C-V3 — NOT Git Bash zip) + sha256sum checksum step. YAML-only + a presence-assertion test (tests/release_yml_windows_matrix.rs). H-WIN-6 (human Release-page inspection) is the named real correctness gate. actionlint clean.

## Adversarial journey (per-story Step-4.5)

- Pass 1: F-WIN4-IMPL-101 (LOW): AC-003 smoke-gate test grepped non-unique `runner.os != 'Windows'` (also on Package(Unix)) → could pass if smoke gate removed. Workflow itself clean (smoke step had no pre-existing YAML if:; no clobber). Fixed (ebc5475: anchor to step name + window).
- Round 2 (A/B/C): A clean, C clean (obs), B found F-001 (MEDIUM: AC-004 + AC-005 both bare whole-file contains("jr-*.zip") — indistinguishable; release-files glob deletion undetectable) + F-002 (LOW: AC-002 rustdoc claimed C-V3 negative but didn't assert it). Fixed (2150355: anchor each to its block + AC-002 C-V3 negative).
- Round 3 (3 passes): found F-1 (LOW cosmetic: rustdoc/messages said "10 lines" but take(5)) + F-2 (LOW fragility: fixed 5-line window tight against future env: insertion). Fixed (3a4cdf0: step_block helper slices anchor→next `- name:` boundary; robust to reformat; wording corrected).
- Final round (3 passes): ALL 3 CLEAN. step_block correct (6-space marker, unique anchors, last-step→EOF, Package block ends before Checksum so negatives safe); all 5 tests discriminating + pass; workflow correct (native msvc build → jr.exe; Compress-Archive resolves; merge-multiple; both globs); EC-002 handled-by-construction; cross-story clean (.gitattributes is S-WIN-5's).

## Verdict: CONVERGED (3-clean final). No spec change (impl matched converged spec). H-WIN-6 = real gate (presence-only tests by design).

## Lesson (positive pattern — codify)

LESSON-PRESENCE-ANCHOR: source-text/presence-grep tests MUST anchor each assertion to its owning step/block (e.g. find(step_name) → slice to next sibling marker) UNLESS the searched token is provably file-unique — in which case document the uniqueness as the anchoring justification. Bare whole-file contains() on a non-unique token is a false-green vector (a sibling occurrence satisfies the assertion; a regression in the intended block goes undetected). This pattern recurred across S-WIN-3 (deny.toml) and S-WIN-4 (release.yml) per-story reviews; S-WIN-4's step_block helper + the AC-001 file-unique-token exception is the exemplar. Apply to S-WIN-5 (ci.yml) and S-WIN-6 (docs) presence tests.
