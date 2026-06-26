# Supply-Chain Soak Research — `softprops/action-gh-release` v3.0.0 → v3.0.1

**Research date:** 2026-06-26
**PR under review:** #557 (Dependabot bump v3.0.0 → v3.0.1)
**Researcher:** research-agent (Corverax / VSDD)
**Verdict (TL;DR):** SOAK-CLOCK = **7 days** old as of 2026-06-26. Routine maintenance/dependency patch. No advisories. No anomalies detected. **Borderline against a 7-day soak floor; below a 14-day floor.** See §6 for the policy call.

---

## 1. Publication timestamp of v3.0.1 (soak clock start)

| Field | Value | Source |
|-------|-------|--------|
| Tag | `v3.0.1` | GitHub Releases API |
| Release `published_at` | **2026-06-19T14:42:32Z** | `GET /repos/softprops/action-gh-release/releases/tags/v3.0.1` |
| Release `created_at` | 2026-06-19T14:42:00Z | same |
| Annotated-tag `tagger.date` | 2026-06-19T14:42:00Z | `GET /git/tags/{sha}` |
| Underlying commit author/committer date | 2026-06-19T14:41:38Z | `GET /commits/718ea10…` |

All four independent timestamps agree to within ~1 minute → **publish date 2026-06-19 (UTC), high confidence.**

**Elapsed time as of 2026-06-26:** 2026-06-19 → 2026-06-26 = **7 days** (exactly one week).

> Confidence: HIGH. The publish timestamp was corroborated across three distinct GitHub API endpoints (release object, annotated-tag object, dereferenced commit). Note: an early WebFetch read of the releases HTML page mis-rendered the year as **2024**; this was a model-extraction artifact, not data. The authoritative API JSON reads consistently show **2026-06-19**, and the v3.0.0 baseline (Node 24 runtime transition, 2026-04-12) only makes sense on a 2026 timeline. The 2024 reading is rejected.

---

## 2. What changed 3.0.0 → 3.0.1

**Release notes (verbatim):** `"maintenance release with updated dependencies"`

**Diff scope:** ~17 commits, 8 files changed, spanning 2026-04-12 → 2026-06-19, authored by **dependabot[bot]** and **Rui Chen (chenrui333)**. (`/compare/v3.0.0...v3.0.1`)

**Nature of changes — routine patch.** No commits touch authentication, token handling, or network/HTTP call logic. Changes are:

- Dependabot dependency bumps (see below)
- Added Dependabot "cooldown" config + updated `pinact` annotations (SHA-pinning hygiene for the action's *own* workflow deps — a supply-chain *hardening* signal, not a risk)
- Docs/config cleanup (clarified issue-link wording in release summaries; removed `.github/FUNDING.yml`)

**Dependency bumps (all patch/minor):**

| Dependency | From → To | Class |
|-----------|-----------|-------|
| `@actions/core` | 3.0.0 → 3.0.1 | production |
| `@actions/github` | 9.1.0 → 9.1.1 | production |
| `actions/setup-node` | 6.3.0 → 6.4.0 | CI |
| `actions/checkout` | 6.0.2 → 6.0.3 | CI |
| `@types/node` | 24.12.2 → 24.13.1 | dev |
| `prettier` | 3.8.2 → 3.8.3 | dev |
| `typescript` | 6.0.2 → 6.0.3 | dev |
| `esbuild` | 0.28.0 → 0.28.1 | dev |
| `vite` | 8.0.14 → 8.0.16 | dev |
| `vitest` / `@vitest/coverage-v8` | 4.1.4 → 4.1.8 | dev |
| `postcss` | 8.5.9 → 8.5.10 | indirect |
| `brace-expansion` | 5.0.5 → 5.0.6 | indirect |

> **Assessment:** Low-risk patch. The two production deps that touch the GitHub API (`@actions/core`, `@actions/github`) move by a single patch version each — no new network destinations or auth surface introduced. **No new top-level dependencies were added.** (Source: WebFetch of the compare view; dev/indirect bumps don't ship in the bundled action runtime but are listed for completeness.)

---

## 3. Maintainer & release legitimacy signals

| Signal | Finding | Assessment |
|--------|---------|------------|
| Publisher | **chenrui333 (Rui Chen)** | Not `softprops` (Doug Tangren, the repo owner) directly — but chenrui333 is a long-standing, recognized co-maintainer/frequent releaser of this action (also published v3.0.0). Consistent with recent release cadence. |
| Commit signed-off | `Signed-off-by: Rui Chen <rui@chenrui.dev>` | Normal DCO sign-off; consistent author identity. |
| Release cadence | v3.0.0 (2026-04-12) → v3.0.1 (2026-06-19), ~9 weeks apart | Normal cadence for a maintenance patch. |
| Tag type | **Annotated** tag (`object.type: tag`), tagger Rui Chen | Annotated tags are the project norm; not a lightweight tag swapped in. |
| Force-push / retroactive edit | None observed | Tag author date, commit date, and release publish date all align to 2026-06-19 within ~1 min. No evidence of a backdated or retroactively re-pointed tag. |
| Account-compromise indicators | None found | No community reports, no force-push storms (cf. the Trivy/trivy-action incident — see §4), no anomalous tag churn. |

> **Assessment:** Provenance looks legitimate and routine. The only nuance worth noting to the security reviewer: the release was cut by **chenrui333**, not the nominal owner `softprops`. This is the established pattern for this repo (chenrui333 also cut v3.0.0), so it is **not** treated as anomalous — but if your policy requires releases from the primary owner account specifically, flag it.

---

## 4. Security advisories / incidents

- **GitHub Security Advisories for softprops/action-gh-release:** **ZERO published advisories** (repo `/security/advisories` page: "There aren't any published security advisories"). No GHSA for any version, including the 3.0.x line.
- **CVE search:** No CVE targeting a vulnerability *within* `softprops/action-gh-release` was found.
- **False-positive cleared:** `CVE-2025-10894` / `GHSA-cxm3-wv7p-598c` surfaced in search but affects the **`nx`** build tool (npm credential-harvesting incident), **not** this action.
- **Context (not this action, but relevant soak-policy rationale):** The broader GitHub Actions ecosystem has seen real supply-chain compromises that justify a soak policy — `tj-actions/changed-files` (CVE-2025-30066, secret exfiltration via logs) and the **aquasecurity/trivy-action** force-push attack (2026-03-19, attacker force-pushed 76 of 77 version tags to malicious commits). **No such activity is associated with action-gh-release.**
- **StepSecurity:** maintains a standard action-advisor entry for this action (advisory tooling presence, not an incident).

> **Assessment:** Clean. No known active vulnerability, no incident history.

---

## 5. Immutable commit SHA for PR pinning

The `v3.0.1` annotated tag dereferences to commit:

```
718ea10b132b3b2eba29c1007bb80653f286566b
```

- Annotated-tag object SHA (the tag itself): `2bb465e97f322d3cb2a965294d483e0d26a67aa9`
- **Commit SHA the tag points to (USE THIS FOR PINNING): `718ea10b132b3b2eba29c1007bb80653f286566b`**
- Commit message: `release 3.0.1` (Signed-off-by: Rui Chen <rui@chenrui.dev>)

For reference, the v3.0.0 baseline tag points to commit `b4309332981a82ec1c5618f44dd2e27cc8bfbfda`.

> **Reviewer action:** Confirm the PR pins to `718ea10b132b3b2eba29c1007bb80653f286566b` (with `# v3.0.1` comment), not to the mutable `v3` / `v3.0.1` tag and not to the tag-object SHA `2bb465e…`. Verified across two independent API reads (`/git/tags/{sha}` deref and `/commits/{sha}`).

---

## 6. SOAK-CLOCK verdict

- **Publish date:** 2026-06-19 (UTC), high confidence
- **Age as of 2026-06-26:** **7 days**
- **Changes:** routine maintenance + dependency patch bumps; no auth/token/network surface change; no new top-level deps
- **Advisories:** none
- **Provenance:** legitimate, normal cadence; released by recognized co-maintainer chenrui333 (same as v3.0.0); no force-push/backdating evidence

**Decision input for the policy owner:**

- If the soak floor is **≤ 7 days** → **PASS** (exactly meets a 7-day floor).
- If the soak floor is **14+ days** → **HOLD** until ~2026-07-03 (14-day) and re-check that the tag still points to `718ea10…` (re-point detection).

**Anomalies flagged:** None material. Two items for reviewer awareness only: (a) released by chenrui333 rather than owner softprops — established pattern for this repo; (b) an early HTML-scrape mis-read the year as 2024 — rejected in favor of corroborated API timestamps.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source sweep: v3.0.1 publish date, changelog, maintainer, SHA, advisories. (Returned project context + confirmed no advisories; did NOT surface exact timestamp/SHA — filled by direct API reads.) |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| WebFetch | 7 | GitHub Releases HTML page; Releases API (release object); git ref/tag/commit API endpoints; `/compare` diff view; `/security/advisories`; advisory GHSA-cxm3-wv7p-598c (false-positive clearance) |
| WebSearch | 2 | v3.0.1 existence/date cross-check; CVE/GHSA/supply-chain incident sweep |
| Training data | 0 areas | All claims sourced from live API/web reads. |

**Total MCP tool calls:** 1 (perplexity_research). Plus 9 WebFetch/WebSearch grounding calls.
**Training data reliance:** low — every load-bearing fact (publish date, commit SHA, diff contents, advisory status) was read from live GitHub API endpoints and cross-corroborated across ≥2 independent endpoints.

### Sources
- Releases API: `https://api.github.com/repos/softprops/action-gh-release/releases/tags/v3.0.1`
- Tag ref: `https://api.github.com/repos/softprops/action-gh-release/git/ref/tags/v3.0.1`
- Annotated tag deref: `https://api.github.com/repos/softprops/action-gh-release/git/tags/2bb465e97f322d3cb2a965294d483e0d26a67aa9`
- Commit: `https://api.github.com/repos/softprops/action-gh-release/commits/718ea10b132b3b2eba29c1007bb80653f286566b`
- Diff: `https://github.com/softprops/action-gh-release/compare/v3.0.0...v3.0.1`
- Advisories: `https://github.com/softprops/action-gh-release/security/advisories`
- False-positive clearance: `https://github.com/advisories/GHSA-cxm3-wv7p-598c` (affects `nx`, not this action)
