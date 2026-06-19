> SUPERSEDED by DEAD-CITATION-CI F2 Iter-2 re-scope: the allowlist sketch and pre-re-scope failure message below are historical. Canonical spec: BC-X.13.001/002/003 + error-taxonomy.md §8 CI-CITE-001.

# Dead-Citation CI Guard: Bash Script vs Rust `#[test]` — Recommendation

**Date:** 2026-06-19
**Type:** general (technology/implementation research)
**Topic:** CI approach for verifying `Detail:`/`See:` file-path citations in `CLAUDE.md` resolve to real on-disk files
**Status:** complete

---

## One-line recommendation

**Implement it as a Rust `#[test]` in `tests/` following the existing `*_release_gate.rs` doc-fallout pattern** — specifically a `tests/claude_md_citations.rs` integration test that parses `CLAUDE.md` for citation grammar and asserts each cited path exists. Do **not** use an off-the-shelf link checker (none match the grammar), and reserve a bash script only as a runner-up for a future multi-file/many-doc sweep.

---

## (a) Primary recommendation: Rust `#[test]` guard — rationale

### Why Rust-test-as-guard wins for THIS repo

1. **Rides `ci-gate` for free; zero workflow surgery.** The required branch-protection check is `ci-gate`, and `ci-gate.needs` already lists `test`. A new `tests/claude_md_citations.rs` is picked up automatically by `cargo test --all-features` (ci.yml line 57) with **no new job and no `ci-gate.needs` edit**. A bash script would need its own job (like `spec-guard`/`check-signing-workflow-injection`) wired into `ci-gate.needs` — exactly the kind of manual wiring the project treats as a fragility class (DEC-096/DEC-097). The Rust path sidesteps that entirely.

2. **Cross-platform by construction (the Windows leg).** The `test` job runs a 3-OS matrix: `ubuntu-latest, macos-latest, windows-latest` (ci.yml line 48). A `cargo test` guard therefore validates citations on Windows too. Critically for a *path-existence* check, this means the guard catches **case-sensitivity and path-separator** defects that a Linux-only bash job would miss — e.g. a citation `Docs/Specs/Foo.md` that resolves on case-insensitive macOS/Windows but is a dead link on Linux, or vice-versa. By contrast, every existing bash guard runs on `ubuntu-latest` only (`spec-guard` at ci.yml line 112; `check-signing-workflow-injection` at line 309). A bash citation guard would be single-OS, leaving the very class of bug it exists to catch partially uncovered.
   - Note: `std::path` + `Path::exists()` resolve relative to the crate root deterministically across all three OSes, and `include_str!("../CLAUDE.md")` embeds the doc at compile time the same way `config_dir_release_gate.rs` embeds `src/config.rs`.

3. **Matches the established doc-fallout test idiom.** The repo already encodes "documentation must stay true to disk" as Rust tests: `base_url_release_gate.rs`, `config_dir_release_gate.rs`, `bulk_await_timeout_release_gate.rs`, `auth_header_release_gate.rs`, and `docs_fallout_windows.rs` all `include_str!` a source/doc file and assert structural invariants with rich failure messages. A citation guard is the same shape (parse text → assert invariant → emit actionable error) and slots into a pattern reviewers already understand. The project's own convention is "test-as-guard for doc/source invariants."

4. **Testable and refactorable under the project's own rules.** A `#[test]` guard is itself subject to `cargo clippy -- -D warnings` (zero-warnings policy) and is idiomatic Rust that can be unit-tested via helper functions (e.g. a pure `extract_citations(&str) -> Vec<Citation>` fn with its own inline `#[cfg(test)]` cases for the grammar edge cases). A bash regex guard cannot easily unit-test its own parser, and the project's larger bash guards (`check-bc-cumulative-counts.sh` at 251 LOC, `check-signing-workflow-injection.sh` at 524 LOC) only got testable by bolting on **separate fixture-suite harnesses** (`tests/spec-count-fixtures/run-tests.sh`, invoked at ci.yml line 130, and the `--self-test` flag at line 323). That's real maintenance overhead the Rust path gets for free via `cargo test`.

5. **CRLF/quoting fragility is a real risk here, and Rust neutralizes it.** The project has a documented history of CRLF/quoting subtlety (INV-1 in `adf.rs`; Windows-parity work in `backfill-release.yml`). A bash guard parsing paths out of prose with `grep`/`sed`/`awk` is exposed to `\r` contamination, word-splitting on spaces in paths, and locale/`IFS` pitfalls. Rust's `str::lines()` and explicit `.trim_end_matches('\r')` (or `split_whitespace`) make the parsing deterministic and reviewable.

### The one genuine cost
A Rust guard compiles into the test binary, adding a marginal compile/test increment. Given the suite already compiles many `*_release_gate.rs` files, this is negligible. It does **not** add a network dependency (no crate needed — pure `std`).

---

## (b) Runner-up: bash `scripts/check-claude-md-citations.sh` — when it'd be preferable

A bash script (wired into `spec-guard` or its own `ci-gate.needs` job) is the right call **only if** the scope grows beyond what a single crate-embedded test should own:

- **Many docs, not just `CLAUDE.md`.** If the guard must sweep dozens of files across `docs/`, ADRs, and specs — including files on the **separate `factory-artifacts` branch** that `spec-guard` already worktree-checks-out (ci.yml lines 121–124) — a bash job that runs *after* that worktree fetch is structurally simpler than threading branch-checkout logic into a `cargo test`. The `.factory/specs/prd/` artifacts are NOT on the working branch; if citations into those must be validated, a test embedded via `include_str!` on the working tree literally cannot see them, whereas the `spec-guard` bash job already has them mounted.
- **You want it to run without a Rust toolchain / Cargo cache** (e.g. a docs-only lint that should pass in a minimal container).
- **The check is a thin `test -f` loop** with no parsing subtlety worth unit-testing.

For the stated scope — `CLAUDE.md` (and "similar docs" on the working branch) — none of these triggers apply, so bash stays the runner-up. If it's later chosen, co-locate it in the existing `spec-guard` job rather than minting a new `ci-gate.needs` entry, and add a `--self-test` fixture harness to match the project's bash-testability convention.

---

## (c) Off-the-shelf tool vs hand-roll: **hand-roll** (verified)

**Use a hand-rolled guard. No off-the-shelf link checker fits the `Detail: path` / `See: path` grammar.** This is the decisive finding from a multi-source Perplexity deep-research sweep of the 2025–2026 Rust link-checking landscape.

Every mainstream checker is built around **markup link constructs** (`[text](path)`, HTML `href`) or **URI-scheme patterns** (`http(s)://`, `mailto:`). **None** detects a bare path mentioned in prose after a `word:` prefix:

| Tool | Latest version (verified) | Detects bare inline `Detail: path`? | Checks local file existence? | Verdict |
|------|---------------------------|-------------------------------------|------------------------------|---------|
| **lychee** (Rust) | **0.24.2** (crates.io, updated 2026-05-01) | No — parses Markdown/HTML links + URI schemes only; bare paths in prose are invisible | Yes, but only for paths used as *link targets* (`--root-dir`/`--base-url`) | Reject — grammar mismatch |
| **markdown-link-check** (npm) | (active; extracts links from Markdown text) | No — Markdown link/`mailto:` syntax only | Yes, for link targets via Node `fs` | Reject — grammar mismatch |
| **cargo-deadlinks** | (Rustdoc-output checker; MSRV 1.45) | No — scans generated Rustdoc HTML `<a href>` only | Yes, `file://` links by default | Reject — wrong surface (HTML output, not source prose) |
| **mlc (Markup Link Checker)** | (HTML+Markdown) | No — markup links only | Yes, absolute+relative paths in links | Reject — grammar mismatch |
| **typos** | n/a | No — spell checker, not a link checker | No | Reject — not a link tool |
| **broken-links** (crate) | n/a | No — website `href` crawler | No (HTTP only) | Reject — website crawler |

Source-grounded conclusion from the research: *"none [of the surveyed tools] offers built-in support for detecting and validating arbitrary inline `word: path` style citations… All tools that do check local file existence do so only when the path appears as a link target in Markdown or HTML, or as part of a URL-like pattern that includes a recognized scheme."* To make these tools see the citations you would have to **rewrite every `Detail: path` into `[path](path)` Markdown** — a large, lossy doc change that alters the rendered form of CLAUDE.md and is far more invasive than a ~60-line guard. Reject that route.

> Tool-version caveat: lychee 0.24.2 is verified against the crates.io registry API (`max_stable_version`, updated 2026-05-01). The other tools' exact semver could not be pinned from the research snapshot; this does not affect the verdict because the rejection is on *capability* (grammar), not version.

---

## (d) Implementation sketch — recommended Rust option

**Location:** `tests/claude_md_citations.rs` (integration test, sibling to the `*_release_gate.rs` files).

**Wiring into ci-gate:** None required. It is collected by `cargo test --all-features` in the `test` job (ci.yml line 57), which is already in `ci-gate.needs`. It runs on all three OSes automatically.

**Citation grammar handled.** Parse `CLAUDE.md` (and, if "similar docs" are in scope on the working tree, a small allowlist of doc paths) for the two prefixes seen in the file: `Detail:` and `See:`. From the CLAUDE.md body these appear as comma/`+`-separated path lists and sometimes alongside symbol-form citations (`file::fn`, `file:~NN`). Rules:

1. Split each line on the prefix; take the trailing remainder.
2. Tokenize the remainder on `,`, `+`, and whitespace.
3. For each token, **keep only path-shaped tokens** — contains `/` and an extension or known dir prefix (`src/`, `docs/`, `tests/`, `scripts/`, `.factory/`, `.github/`). This is the load-bearing filter that avoids false positives on prose.
4. **Strip symbol/anchor suffixes** before existence-checking, per the project's own citation conventions (CLAUDE.md "Citation form" + "Citation discipline" notes):
   - `path::fn` → drop `::fn` (symbol-form).
   - `path:~NN` and `path:NN` → drop `:line` (line-ref form; `~` = approximate).
   - trailing `)`, `,`, `.`, backticks → trim.
5. Resolve each cleaned path relative to `CARGO_MANIFEST_DIR` (crate root) and assert `Path::new(p).exists()`.
6. **Skip, with an explicit allowlist**, paths that intentionally live off the working branch (e.g. `.factory/specs/prd/...`, `.factory/research/...`, `.factory/holdout-scenarios/...`) — these are on `factory-artifacts`/other branches and are NOT present in a normal working-tree checkout. Document each skip with a comment, mirroring how the release-gate tests document their scope. (If validating those later becomes required, that is precisely the trigger to move to the bash runner-up that runs after `spec-guard`'s worktree fetch.)

**Structure (mirrors the release-gate idiom):**

```rust
//! Doc-fallout guard: every `Detail:`/`See:` file-path citation in CLAUDE.md
//! must resolve to a real on-disk file. Catches citation drift after refactors.

const DOC: &str = include_str!("../CLAUDE.md");

// Pure, unit-testable parser — gives the grammar its own #[cfg(test)] coverage.
fn extract_path_citations(doc: &str) -> Vec<String> { /* steps 1–4 above */ }

#[test]
fn test_claude_md_citations_resolve_to_real_files() {
    let root = env!("CARGO_MANIFEST_DIR");
    let mut dead = Vec::new();
    for cite in extract_path_citations(DOC) {
        if is_off_working_branch_allowlisted(&cite) { continue; }
        let p = std::path::Path::new(root).join(&cite);
        if !p.exists() { dead.push(cite); }
    }
    assert!(
        dead.is_empty(),
        "CLAUDE.md cites file paths that do not exist on disk:\n  {}\n\
         Fix the citation or restore the file. If the path is intentionally on a \
         non-working branch (factory-artifacts), add it to the allowlist with a comment.",
        dead.join("\n  ")
    );
}

#[cfg(test)]
mod parser_tests {
    // grammar edge cases: `path::fn`, `path:~NN`, comma/`+` lists, trailing `)`,
    // CRLF lines (trim `\r`), prose tokens that must NOT be treated as paths.
}
```

**Cross-platform note:** use `Path::join` (not string concat) so the separator is correct on Windows, and `trim_end_matches('\r')` on each line so CRLF checkouts on the Windows leg don't corrupt the trailing token. These two lines are the entire cross-platform surface — and they're the reason the Rust+matrix approach is strictly safer than a Linux-only bash guard for a *path-existence* check.

**Zero-warnings compliance:** pure `std`, no new dependency, no `#[allow]`. Refactor the parser into small functions rather than suppressing any `clippy` lint, per project policy.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source sweep of 2025–2026 Rust link-integrity tooling (lychee, markdown-link-check, cargo-deadlinks, typos, mlc, broken-links); whether any detects bare inline `word: path` citations vs only markdown/URI links; local-file-existence support. `reasoning_effort=high`. |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily (all) | 0 | — |
| WebFetch | 2 | crates.io lychee version (registry API → 0.24.2, 2026-05-01); crates.io HTML page (client-rendered, no data — superseded by API call) |
| WebSearch | 0 | — |
| Training data | 2 areas | (1) Rust `std::path` / `include_str!` / `CARGO_MANIFEST_DIR` mechanics for the implementation sketch; (2) GitHub Actions `ci-gate.needs` semantics — both cross-checked against the repo's actual ci.yml (read directly, not assumed) |

**Repo grounding (read directly, not researched):** `.github/workflows/ci.yml` (matrix OSes, `test`/`spec-guard` jobs, `ci-gate.needs`, bash-guard wiring, factory-artifacts worktree fetch); `tests/config_dir_release_gate.rs` (the `include_str!` doc-fallout pattern); `scripts/*.sh` inventory; CLAUDE.md citation-form/discipline conventions.

**Total MCP tool calls:** 1 (Perplexity deep research) + 2 WebFetch = 3 external calls.
**Training data reliance:** low — the load-bearing tool-capability claim is from `perplexity_research`; lychee's version is registry-verified; all repo-specific wiring claims are from direct file reads.
