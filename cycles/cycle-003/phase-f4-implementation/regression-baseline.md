# F4 Regression Baseline — cycle-003

- **develop SHA:** `87f17aff8f246d5364fb832e37b1bfc81d6c0ea8`
- **Timestamp (UTC):** 2026-09-02T05:19:19Z

## Signals

1. `cargo build --tests`: **clean** — `Finished \`dev\` profile [unoptimized + debuginfo] target(s) in 0.26s` (already built/cached from prior work; entire test tree — unit + all integration tests — compiles with zero errors).
2. `cargo test --lib`: **PASS** — `test result: ok. 1203 passed; 0 failed; 11 ignored; 0 measured; 0 filtered out; finished in 1.17s`
3. `cargo clippy --all-targets --all-features -- -D warnings`: **clean** — zero warnings, `Finished \`dev\` profile [unoptimized + debuginfo] target(s) in 6m 14s`
4. `cargo fmt --all -- --check`: **clean** — no diffs, no output

## Notes

Full integration suite deferred to per-PR ci-gate (authoritative); this baseline confirms develop compiles + unit tests + lint/fmt are green. develop @ 87f17aff is the released v0.7.0-dev.3 tip (cycle-002 F7 recorded 4660/0/106 full-suite PASS, DEC-311).

## Verdict

**GREEN — safe to start F4 Wave 1.**
