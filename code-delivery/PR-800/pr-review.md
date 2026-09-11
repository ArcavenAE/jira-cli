> **VERDICT: APPROVE.** Posted as a `--comment` review only because GitHub
> structurally forbids approving one's own pull request (`Can not approve your own
> pull request`) — the authenticated account is this PR's author. Treat this as an
> approving fresh-eyes review; it carries no blocking findings. A human reviewer
> must supply the formal green check for the code-owner requirement.

## Fresh-Eyes PR Review — PR #800

**Title:** `fix(deps): bump chacha20 0.10.0 -> 0.10.2 (yanked crate)`
**Branch:** `fix/deps-chacha20-yanked` → `develop`
**Verdict:** **APPROVE** — no blocking findings, no trivial-fixable findings.

---

### Summary

Cargo.lock-only transitive dependency bump clearing a `cargo deny` yanked-crate
warning. Every factual claim in the PR description was independently verified
against the crates.io registry rather than taken on trust. All claims hold.

---

### Checklist Results

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — single file, single hunk, entirely on-topic |
| 2 | Description accuracy | PASS — every claim independently confirmed |
| 3 | Test coverage | N/A — lockfile-only, no changed source lines to cover |
| 4 | Demo evidence | N/A — no user-visible behavior change (dependency hygiene) |
| 5 | Commit quality | PASS — Conventional Commits `fix(deps):`, clear subject |
| 6 | Diff size | PASS — +2/−2, far under the 500-line flag threshold |
| 7 | Missing changes | PASS — nothing further required; `Cargo.toml` correctly untouched |
| 8 | Dependency status | N/A — no upstream PR dependencies |

---

### Verification Performed

**1. Diff is actually Cargo.lock-only — CONFIRMED.**
`gh pr diff 800 --name-only` returns exactly one path: `Cargo.lock`. The diff
contains exactly one `diff --git` header (verified by count, not by eyeballing),
totalling +2/−2. No `Cargo.toml` manifest edit, no `src/` change, no workflow or
CI file, no documentation change. There is no hidden second hunk.

**2. Version direction and yank rationale are internally consistent — CONFIRMED.**
The head branch's `Cargo.lock` entry (line ~255) reads:

```
name = "chacha20"
version = "0.10.2"
checksum = "65c35e4b699c7e15ccbe7ee35c005e4fc0a278d22238a2857e6ce2dadeda1b06"
```

Rather than trusting the PR body, I queried the crates.io sparse index
(`https://index.crates.io/ch/ac/chacha20`) directly:

| Version | Yanked | Checksum (prefix) |
|---------|--------|-------------------|
| 0.10.0 | **true** | `6f8d9832…eb5724` (matches the REMOVED lockfile line) |
| 0.10.1 | **true** | `d524456b…40a2` |
| 0.10.2 | **false** | `65c35e4b…eda1b06` (byte-identical to the ADDED lockfile line) |

Both checksums in the diff match the registry exactly, the bump direction is
forward, and the yanked/not-yanked framing in the description is accurate for all
three versions. The intermediate `0.10.1` being yanked as well justifies skipping
straight to `0.10.2` rather than a single-patch step.

The `(via rand 0.10.2)` attribution is also correct: `rand 0.10.2` (Cargo.lock
line ~1721) is the sole crate listing `chacha20` in its dependency array, so this
is genuinely transitive and no direct dependency was introduced. `chacha20 0.10.2`
in turn pulls `cfg-if`, `cpufeatures`, `rand_core 0.10.1` — no new or surprising
transitive additions appear in the diff, consistent with a same-minor patch bump.

Soak claim verified: crates.io reports `0.10.2` published `2026-08-27T17:51:13Z`,
which is exactly the date claimed and exactly 14 days of aging as of the
2026-09-10 sweep.

**3. Security relevance — routine hygiene, NOT a misdescribed advisory fix.**
Neither yanked version carries a `yank_message` on crates.io, and there is no
RustSec advisory in play: the `Deny (licenses + vulnerabilities)` CI job — which
runs the RustSec advisory database — passes, and the pre-fix condition reported
by the sweep was a `yanked` warning rather than a vulnerability hit. Those are
distinct `cargo deny` categories, so the description's "yanked-crate hygiene"
framing is the correct characterization. Nothing here looks like an
advisory-driven bump dressed up as routine maintenance.

One observation recorded for completeness, not as a finding: `chacha20` sits
beneath `rand`, so a *correctness* regression in a stream cipher there would be
security-adjacent even absent a formal advisory. No evidence of any such
regression exists — this is a forward move within the same minor version, and the
full test suite plus all three OS matrices pass on it.

---

### CI Evidence

24 of 24 checks green on the head commit, including `CI Gate` (the single required
status check), `Deny (licenses + vulnerabilities)`, `MSRV (1.85.0)`,
`Test` on ubuntu/macos/windows, `Clippy` on ubuntu/windows, `Coverage`,
`Secret Scan (gitleaks)`, `Spec Guards`, `dependency-review`, and all 8 mutation
shards plus the aggregate.

Minor note, non-blocking and requiring no change: the sweep summary cited "23/23
checks"; the actual count is 24. Purely a bookkeeping detail in the summary, not
in the PR itself, and it does not affect the merge decision.

---

### Findings

None. No blocking findings, no suggestions, no nits against the diff.

This is not a rubber stamp — what was verified is enumerated above: the file scope
was checked mechanically rather than visually, both checksums were matched against
the crates.io registry rather than accepted from the description, the yank status
of all three relevant versions was pulled from the index directly, the publish date
and soak period were confirmed, the transitive dependency path through `rand` was
traced in the lockfile, and the security-versus-hygiene classification was
corroborated against the passing advisory-scanning CI job.

**Recommendation: APPROVE and merge.**
