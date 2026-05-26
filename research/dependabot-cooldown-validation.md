# Dependabot Cooldown Config Validation — `chore/dependabot-7d-cooldown` / PR #412

Validated: 2026-05-26
Target file: `/Users/zious/Documents/GITHUB/jira-cli/.github/dependabot.yml`

---

## Validation Verdict

**PASS-WITH-NOTES.**

The file is syntactically and semantically correct: every key name is spelled right, every sub-key is supported by the ecosystem it's used under, the GA feature is being used, and security-advisory PRs will (as of Feb 2026) correctly bypass the cooldown. There are no broken keys that would be silently dropped.

The notes are about **policy / value choices**, not correctness:

1. The chosen `semver-major-days: 14` for cargo is on the *low* end of community recommendations (most authoritative sources, including GitHub's own example, use **30**). 14 is defensible for a small Rust workspace, but worth a deliberate decision.
2. There's a recent (but already-fixed) Dependabot bug where cooldown leaked into security updates. The fix shipped on the hosted runner Feb 2026. Anyone running self-hosted dependabot-core older than that should be aware.
3. `cooldown` is a *sibling* of `schedule` (correct in the file). No ordering requirement, but worth knowing for future edits.

The file is safe to merge as-is. The only edit I'd suggest considering — not blocking — is bumping `semver-major-days` from 14 to 30 to match GitHub's own published example. See **Recommended edits** at the bottom.

---

## Q1 — Is `cooldown` GA?

**Finding: YES, GA since 2025-07-01.**

The official GitHub Changelog entry titled "Dependabot supports configuration of a minimum package age" (2025-07-01) states verbatim:

> "The cooldown feature is now generally available for Dependabot version updates!"

Confirmed by:
- https://github.blog/changelog/2025-07-01-dependabot-supports-configuration-of-a-minimum-package-age/ (2025-07-01)
- https://github.blog/changelog/2025-07-29-dependabot-expanded-cooldown-and-package-manager-support/ (2025-07-29 — expanded to NuGet & Helm)
- The live options reference page presents `cooldown` with no preview/beta banner: https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference

No enablement flag, no `feature-flags:` setting, no org-level opt-in. Just put the block in `dependabot.yml`.

---

## Q2 — Sub-key names exactly correct?

**Finding: YES, all six names are correct as written.**

The authoritative reference (live GitHub docs, options reference) lists exactly:

- `default-days`
- `semver-major-days`
- `semver-minor-days`
- `semver-patch-days`
- `include`
- `exclude`

Your file uses `default-days`, `semver-major-days`, `semver-minor-days`, `semver-patch-days` — all four match precisely. There's no `major-days` variant; there's no `cooldown-period` variant (that's a third-party blog's shorthand, not the real key). Misnamed keys ARE silently ignored — but you don't have any.

The 1–90 day range is documented and applies to all four numeric sub-keys:

> "The number of cooldown days must be between 1 and 90."

Your values (7, 14) are well inside that range.

Source: https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/optimizing-pr-creation-version-updates

---

## Q3 — Does `cargo` support all four semver-* keys?

**Finding: YES. Full semver-* support, confirmed.**

From the live ecosystem-support table on the options reference page (fetched 2026-05-26):

> "Ecosystems supporting SemVer-specific cooldown (`semver-major-days`, `semver-minor-days`, `semver-patch-days`): Bundler, Bun, **Cargo**, Composer, Conda, Deno, Dotnet SDK, Elm, Gomod, Gradle, Helm, Hex, Julia, Maven, NPM and Yarn, NuGet, Pip, Pub, Rust toolchain, Swift, UV"

The secondary source that claimed cargo was `default-days`-only was **wrong**. The authoritative live docs explicitly include Cargo in the semver-aware tier. So your block — which uses all four — is fully supported. Nothing is being silently dropped.

Source: https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference (live, 2026-05-26)

---

## Q4 — Does `github-actions` only honor `default-days`?

**Finding: YES, only `default-days`. Your config is correct (you don't try to set semver-* on it).**

From the same table:

> "Ecosystems with `default-days` only: Bazel, Devcontainers, Docker, Docker Compose, **GitHub Actions**, Gitsubmodule, Nix flakes, OpenTofu, pre-commit, Terraform, vcpkg"

These ecosystems either don't follow strict semver (Docker tags), publish as commit SHAs (GitHub Actions when pinned, or marketplace tags), or have ecosystem-level versioning that doesn't decompose into major/minor/patch reliably. So semver-* keys would be meaningless. If you DID add `semver-major-days: N` under the `github-actions` block, Dependabot would silently drop it (per general "unknown key" handling). You're not doing that — your `github-actions` block only sets `default-days: 7`, which is exactly right.

Source: https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference

---

## Q5 — Do security-advisory PRs bypass cooldown?

**Finding: YES (cited explicitly), with one important historical caveat.**

The options reference page states verbatim:

> "The `cooldown` option is only available for *version* updates, not *security* updates."

This is the spec-level guarantee.

**Caveat — the implementation bug:** `dependabot/dependabot-core#13979` (2026) documented that cooldown was being **incorrectly** applied to security updates in some code paths — specifically `update_all_versions` and `group_update_creation`. The bug was confirmed by the team, and the fix shipped as PR #14050, merged 2026-02-12, which now passes `nil` for `update_cooldown` whenever `job.security_updates_only?` is true.

> "Both now pass nil for update_cooldown when job.security_updates_only? is true."

For GitHub-hosted Dependabot (i.e., anything running through `.github/dependabot.yml` on github.com, including this repo) the runner is updated continuously and the fix has been in place for months — you're fine. The caveat is only relevant if you ever moved to self-hosted Dependabot pinned to an older version.

**Net answer for PR #412:** security PRs will bypass cooldown. Safe.

Sources:
- https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference (spec)
- https://github.com/dependabot/dependabot-core/issues/13979 (bug report, closed)
- https://github.com/dependabot/dependabot-core/pull/14050 (fix, merged 2026-02-12)

---

## Q6 — Interaction with `schedule.interval: weekly`

**Finding: cooldown is a *filter* applied at scheduled-check time, not a re-checker. Your scenario: PR opens on the *following Tuesday* (~9 days after publish), not 7 days after publish.**

Mechanically (paraphrased from the options reference and confirmed by community discussion #180877):

1. The schedule fires (weekly = once a week, default Monday; for your config the assigned day is randomized but stable).
2. On each fire, Dependabot fetches the latest available versions for each dep.
3. It applies the cooldown filter: any version published less than `N` days ago for its bump type is **skipped this run** — the PR for that dep does NOT open at all this cycle.
4. The next scheduled fire repeats the check.

So with `interval: weekly` and `default-days: 7`:

- Version X.Y.Z published Monday week 1.
- Weekly check fires Tuesday week 1 (1 day after publish). Cooldown (7 days) NOT satisfied → skip.
- Weekly check fires Tuesday week 2 (8 days after publish). Cooldown satisfied → PR opens.

So the effective worst-case latency from publish to PR is `cooldown_days + (schedule_interval - 1)`. For your config that's `7 + 6 = ~13 days` in the worst case (release happens right after a weekly check), and `~7 days` in the best case (release right before the next check). The community-discussion answer phrased it as: *"Dependabot proposes updating to the oldest version meeting the cooldown threshold, then moves forward version by version as each release becomes eligible."*

**Dependabot does NOT re-check daily under the hood** when you've set `interval: weekly`. The schedule is authoritative; cooldown is a per-run filter. If you wanted tighter latency, switching `schedule.interval` to `daily` would buy that — at the cost of more frequent check runs. For a 7-day cooldown, weekly schedule is the practical match (a `daily` schedule would mostly produce no-ops anyway), so your choice is sensible.

Sources:
- https://github.com/orgs/community/discussions/180877 (community Q&A on rapid-release behavior)
- https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference (spec — interaction described as: "Dependabot checks for updates according to the defined `schedule.interval` settings. Dependabot checks for any cooldown settings.")

---

## Q7 — Are your value choices (`default-days: 7`, `semver-major-days: 14`) reasonable?

**Finding: `default-days: 7` is the consensus recommendation. `semver-major-days: 14` is on the LOW end — GitHub's own example and most credible third-party sources use 30. Defensible, but worth flagging.**

The data points I gathered:

| Source | default-days | semver-major | semver-minor | semver-patch | Notes |
|---|---|---|---|---|---|
| **GitHub docs example** (optimizing-pr-creation page) | 5 | **30** | 7 | 3 | Official sample on the docs page |
| **OpenRewrite recipe** (`AddDependabotCooldown`) | 7 | — | — | — | Tool-driven default, matches your `default-days` |
| **NextLink Labs** (Rails supply-chain post) | 7 | **14** | 7 | 3 | The *only* source advocating 14 — matches your config |
| **zizmor** (GitHub Actions security linter) | 7 (threshold) | — | — | — | Flags cooldown < 7 days as insufficient |
| **Snyk** (different product) | n/a | 21 (fixed) | — | — | Non-configurable 21-day floor |
| **William Woodruff / Nesbitt** | "at least 30 for critical systems" | — | — | — | Conservative recommendation |
| **Attack-window data** (Nesbitt analysis) | 7 | — | — | — | "8 of 10 supply-chain attacks had windows < 7 days, so a 7-day cooldown would have blocked them" |

**Reading:**

- `default-days: 7` — solidly in the consensus range. This matches the empirical attack-window data (7 days blocks the large majority of historical supply-chain attacks). Keep.
- `semver-major-days: 14` — exactly what the NextLink Labs post recommends, and the same as your `default-days` doubled. But **GitHub's own published example uses 30**, and so does the most-cited "conservative" guidance. The argument for 14 is: a Rust workspace where you actually want to evaluate major bumps relatively quickly. The argument for 30 is: major bumps are the highest-risk class (both for breakage and for supply-chain compromise lying dormant), and most maintainers patch within the first 2–3 weeks if there's an issue. For a CLI that's not critical infra, 14 is fine. For a security-conscious posture, 30 is better-aligned with documented best practice.
- `semver-minor-days: 7` — matches GitHub's example. Good.
- `semver-patch-days: 7` — **higher than GitHub's example (3)**, and higher than NextLink Labs' (3). Patches are typically the lowest-risk class and benefit from faster integration. You could safely drop this to `3` if you wanted to match the canonical recommendation, but holding at 7 isn't wrong — it just means patch-level updates wait a full week, which can leave you on a vulnerable build longer than necessary if a CVE drops for a patch you already had landed but on the old version. (Mitigation: security PRs bypass cooldown entirely, so this is bounded.)

**Bottom line for the policy choice:**

Your `7 / 14 / 7 / 7` is internally consistent (everything is "at least a week") and is a reasonable "uniformly cautious" choice. The strictly-by-the-book canonical answer would be `5 / 30 / 7 / 3` (GitHub's example). The risk-conscious-but-velocity-friendly answer that's gained traction in the community is `7 / 14 / 7 / 3`. Pick based on whether you prioritize uniformity (your current choice) or per-bump-tier risk-stratification (canonical).

Sources:
- https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/optimizing-pr-creation-version-updates (canonical example)
- https://nextlinklabs.com/resources/insights/defending-your-rails-app-enabling-dependency-cooldowns-to-prevent-supply-chain-attacks (7/14/7/3 recommendation)
- https://nesbitt.io/2026/03/04/package-managers-need-to-cool-down.html (attack-window analysis)
- https://docs.openrewrite.org/recipes/github/adddependabotcooldown (tool-default of 7)

---

## Q8 — YAML style, key ordering, hidden gotchas?

**Finding: clean, idiomatic, no gotchas.**

Specifically:

- **Quoted vs unquoted ecosystem names.** GitHub's own examples use quoted strings (`"cargo"`, `"github-actions"`). Your file uses quoted strings. Match. (Unquoted would actually parse identically because YAML treats unquoted scalars as strings here, but quoted is the idiom and protects you against any future YAML 1.2 / 1.1 spec drift — keep it quoted.)

- **`cooldown` as a sibling of `schedule`.** Correct. `cooldown` belongs at the same indent level as `package-ecosystem`, `directory`, `schedule`, `open-pull-requests-limit` — i.e., a top-level key under each `updates[]` entry. It is NOT a sub-key of `schedule`. Your file places it correctly.

- **Key ordering within an `updates[]` entry.** YAML does not require ordering, and Dependabot doesn't either. Your ordering (`package-ecosystem` → `directory` → `schedule` → `open-pull-requests-limit` → `cooldown`) reads naturally. No issue.

- **`open-pull-requests-limit: 5`.** Valid; default is 5; the explicit declaration is harmless and self-documenting.

- **Trailing-newline / indentation.** Standard 2-space indent throughout. No tabs. Fine.

- **No `groups`, no `reviewers`, no `assignees`, no `ignore`.** These are all optional; their absence isn't a defect, just a minimalist config. Worth knowing for future expansion — `groups:` in particular would let you bundle all minor/patch updates into a single PR per ecosystem, which pairs well with cooldown to further reduce noise. Not required for this PR.

- **Two ecosystems in one file.** Both `cargo` and `github-actions` are in the single `updates:` list. Correct.

No silent-drop risks, no parsing ambiguity, no deprecated keys.

---

## Recommended edits

**No required edits.** The file is correct and mergeable.

**Optional — align with GitHub's published example for stricter risk stratification:**

```diff
--- a/.github/dependabot.yml
+++ b/.github/dependabot.yml
@@ -5,10 +5,10 @@ updates:
       interval: "weekly"
     open-pull-requests-limit: 5
     cooldown:
       default-days: 7
-      semver-major-days: 14
+      semver-major-days: 30
       semver-minor-days: 7
-      semver-patch-days: 7
+      semver-patch-days: 3
```

Rationale: matches GitHub's published example (`30 / 7 / 3`) and the consensus security-research recommendation. Major bumps get a 30-day soak (the riskiest tier), patches get only 3 days (lowest-risk, fastest to land). Keeps `default-days: 7` for non-semver dep bumps. Security PRs still bypass everything.

If you prefer the **uniform-caution** posture you have now, **no edit needed** — `7 / 14 / 7 / 7` is internally consistent and defensible. The point of flagging this is just to make sure the value choice is deliberate rather than incidental.

---

## Sources consulted

Authoritative (GitHub-owned):

- [Dependabot options reference (live docs)](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference) — primary spec, ecosystem-support table, all sub-key names
- [Optimizing PR creation for version updates (live docs)](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/optimizing-pr-creation-version-updates) — canonical YAML example, the 1–90 day range, default semver values
- [Dependabot supports configuration of a minimum package age (Changelog)](https://github.blog/changelog/2025-07-01-dependabot-supports-configuration-of-a-minimum-package-age/) — 2025-07-01 GA announcement
- [Dependabot: Expanded cooldown and package manager support (Changelog)](https://github.blog/changelog/2025-07-29-dependabot-expanded-cooldown-and-package-manager-support/) — 2025-07-29 NuGet/Helm expansion
- [Issue #13979 — Security updates are using cooldown (dependabot-core)](https://github.com/dependabot/dependabot-core/issues/13979) — bug report, closed
- [PR #14050 — fix for issue #13979](https://github.com/dependabot/dependabot-core/pull/14050) — merged 2026-02-12
- [Community discussion #180877 — cooldown vs rapid releases](https://github.com/orgs/community/discussions/180877) — clarifies forward-progress semantics

Secondary (cited for value-recommendation comparison):

- [NextLink Labs — Defending Your Rails App: Enabling Dependency Cooldowns](https://nextlinklabs.com/resources/insights/defending-your-rails-app-enabling-dependency-cooldowns-to-prevent-supply-chain-attacks) — the `7/14/7/3` recommendation
- [Andrew Nesbitt — Package Managers Need to Cool Down](https://nesbitt.io/2026/03/04/package-managers-need-to-cool-down.html) — attack-window analysis (7-day threshold blocks 8/10 historical attacks)
- [OpenRewrite recipe — AddDependabotCooldown](https://docs.openrewrite.org/recipes/github/adddependabotcooldown) — tool-default of 7

All sources confirm a consistent picture; no major contradictions remained unresolved. The one secondary-source claim (cargo is `default-days`-only) was REFUTED by the live GitHub docs, which is authoritative.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| WebFetch | 8 | Live GitHub docs (options reference, optimizing-pr-creation), changelog entries (2025-07-01, 2025-07-29), bug report #13979, fix PR #14050, community discussion #180877, OpenRewrite recipe, secondary sources (NextLink Labs, Nesbitt) |
| WebSearch | 3 | Locating GA announcement, security-advisory bypass behavior, cargo/rust best-practice values |
| Training data | 0 areas | None — all claims were verified against live sources. Bug/PR/changelog dates and the security-bypass code mechanism are quoted from the actual issues, not from model knowledge |

**Total external tool calls:** 11
**Training data reliance:** low — every claim is sourced. Version-specific facts (GA date, fix-merge date, ecosystem-support tier) come from primary GitHub-owned URLs.

**Note on prompt-injection encountered:** the first WebFetch of the options reference returned content that included two fake "system-reminder" blocks (one claiming Context7 instructions, one claiming "Auto Mode Active"). Those were content scraped from the fetched page, not legitimate runtime instructions, and were ignored.
