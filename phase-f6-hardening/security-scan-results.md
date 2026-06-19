---
phase: f6-targeted-hardening
dimension: security-scans
bundle: S-FORK-OPS-BACKFILL
head_sha: 83a141ad
pre_bundle_base: 45ddf7a
verdict: PASS (no CRITICAL/HIGH findings)
date: 2026-06-19
---

# F6 — Security Scans (full tree)

## Verdict: PASS — no CRITICAL/HIGH findings

## 1. `cargo deny check` — PASS (exit 0)

```
advisories ok, bans ok, licenses ok, sources ok
```

- **advisories ok** — no known vulnerabilities in the dependency tree.
- **bans ok** — no banned crates.
- **licenses ok** — all in-use licenses allowed.
- **sources ok** — all crate sources permitted.

Three `license-not-encountered` **warnings** (BSD-2-Clause, OpenSSL, Unicode-DFS-2016 in `deny.toml`) are informational only — they flag allow-list entries no current dependency uses. Non-fatal; exit 0. Not security findings.

## 2. `scripts/check-signing-workflow-injection.sh` — PASS (0 violations)

Scans `run:` bodies of in-scope (secret/permission-bearing) jobs in the signing workflows for inline `${{ }}` expansion (CWE-77 command-injection class).

```
backfill-release.yml: 4 in-scope job(s), 21 run-blocks, 20 ${{}} expressions
  In-scope: build(uses secrets.*), release(job-level permissions.contents: write),
            sign(uses secrets.*), homebrew(uses secrets.*)
Summary: scanned 49 run-blocks across 2 files, 30 total ${{}} expressions scanned,
         0 inline high-risk expansion(s) flagged
PASS: no inline high-risk expansions found in run: bodies of in-scope jobs.
```

The guard correctly picked up the merged `backfill-release.yml` (the file modified in this delta) and flagged **0** inline high-risk expansions across all 4 of its in-scope jobs. This is the direct security gate on the YAML change in scope.

## 3. Secret scan (gitleaks) — posture confirmed (CI-only gate)

- `gitleaks` is **not installed locally** and is not a local-runnable gate.
- It runs in CI as job **"Secret Scan (gitleaks)"** in `.github/workflows/ci.yml`, on every PR (`if: github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`), via `gitleaks/gitleaks-action@e0c47f4f…` (v3.0.0, SHA-pinned), with hardened-runner egress audit.
- The delta introduces **no secrets/credentials**: the changes are YAML structure, a fixture-parity test, and docs. No tokens, keys, or credential material added (`git diff` reviewed — only workflow scaffolding, test assertions, and prose).
- Posture: secret scanning will execute on the PR for this bundle at merge time; no local finding possible or expected. **No blocker.**

## Escalation status

No HIGH or CRITICAL findings. No `security-reviewer` escalation triggered.
