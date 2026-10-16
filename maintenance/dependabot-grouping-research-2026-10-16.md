# Dependabot Grouping and Cooldown-Gap Research (2026-10-16)

**Type:** general (CI/supply-chain configuration)
**Target file:** `.github/dependabot.yml`. It currently has daily schedules, `open-pull-requests-limit: 5`, and `cooldown` (7d default, 30d major for cargo) on `cargo` and `github-actions`. It has no `groups`.
**Status:** complete. Inconclusive items are flagged inline as **[UNVERIFIED]** or **[CONFLICT]**.

Confidence key: **[DOC]** means verified on docs.github.com. **[CORE]** means verified in a dependabot-core issue or PR. **[2ND]** means a secondary source (a community discussion, or deepwiki's generated code walkthrough). **[TD]** means training data or inference.

---

## 1. `groups` syntax and semantics

### 1.1 Keys

| Key | Semantics | Source |
|---|---|---|
| `patterns` / `exclude-patterns` | These match dependency names, and `*` is a wildcard. If a name matches both, it is excluded from the group. | [DOC] options reference |
| `dependency-type` | Values are `production` or `development`. **It is supported only by bundler, composer, mix, maven, npm and pip, so it does not apply to cargo or github-actions.** | [DOC] options reference |
| `update-types` | Values are `major`, `minor` and `patch`. The default is all of them. Note that `ignore.update-types` uses a different syntax (`version-update:semver-minor`). | [DOC] options reference |
| `applies-to` | Values are `version-updates` or `security-updates`. **If omitted, the group applies to version updates.** | [DOC] options reference; [DOC] optimizing-pr-creation |
| `group-by: dependency-name` | Groups the same dependency across several directories of one ecosystem. Version updates only. Not relevant here because we have a single directory. | [DOC] options reference |
| Group ordering | "Dependabot creates groups in the order they appear in your `dependabot.yml` file. If a dependency update could belong to more than one group, it is only assigned to the first group it matches with." Updates that match no group get individual PRs. | [DOC] configure-security-updates |

### 1.2 Cargo pre-1.0 versions (load-bearing for this repo)

Dependabot classifies updates numerically: `0.5.x -> 0.6.x` counts as **`minor`**, not `major`. This applies to both group `update-types` and `ignore` update-types. In dependabot-core#7795 a maintainer says pre-1.0 versions are treated the same way as later ones and declines a Rust-specific exception; that issue was closed in Nov 2023 with this behavior unchanged. **[CORE]**

I found no 2025–2026 change to this behavior. One Perplexity answer claimed the opposite, but it contradicted itself ("major component changes from 0 to 0"), so I discarded it. **[CONFLICT, resolved in favour of #7795]**

Consequences for this repo:
- `update-types: ["minor", "patch"]` over `*` **would** sweep in Cargo-breaking bumps. Examples are `reqwest 0.13->0.14`, `rand 0.10->0.11` and `pulldown-cmark 0.13->0.14`. Cargo.toml has 18 direct pre-1.0 dependencies.
- `=0.0.12 -> =0.0.13` for `saphyr-parser` would be classified as **patch**, even though 0.0.x has no semver guarantee.
- **The existing comment in `dependabot.yml` is probably wrong.** It says "Majors (in Rust, also pre-1.0 minor bumps)" get `semver-major-days: 30`. If cooldown uses the same classifier, pre-1.0 minor bumps actually get the **7-day minor** cooldown. **[UNVERIFIED]**: I found no source covering cooldown's classifier specifically, but #7795 says ignore rules and groups share one classifier, and nothing suggests cooldown differs. Cooldown is configured per ecosystem block, so it cannot give some dependencies 30 days and others 7. Getting a 30-day hold on pre-1.0 minors would require either `semver-minor-days: 30` for all crates, or an `ignore` rule with manual bumps.

The only way to express "patch + minor, but no pre-1.0 minor" is through dependency **names**. Groups AND their criteria together, so it takes two groups: patch for everything, and minor for everything except the pre-1.0 crates. See §4.

### 1.3 Cooldown inside groups

- Cooldown is evaluated **per dependency**: "If a dependency's new release falls within its cooldown period, Dependabot skips updating the version for that dependency." **[DOC]** A grouped PR therefore contains only the members that are past their cooldown. Members still cooling are left out and are not held back as a set. **[DOC + 2ND]**
- One known leak: dependabot-core#14683 (npm, 2026) reports that transitive lockfile dependencies inside a grouped update can escape the cooldown filter. I have not confirmed this for cargo. **[CORE, npm only]**
- Cooldown is "only available for version updates, not security updates", and the 3-day default (introduced 2026-07-14) "does not apply to security updates". **[DOC]**

### 1.4 `open-pull-requests-limit`

- The limit counts **open PRs**, so one grouped PR uses one slot no matter how many dependencies it contains. **[DOC]**
- Security-update PRs have "a separate, fixed limit of 10" and do not use version-update slots. **[DOC]**

### 1.5 Comment commands on grouped PRs

- `@dependabot rebase` and `@dependabot recreate` are general commands and work on grouped PRs. `recreate` "overwrit[es] any edits". The errors page tells you to "Use the `@dependabot recreate` comment on the pull request to build the group again." **[DOC]**
- Commands specific to grouped PRs (both version and security groups):
  - `@dependabot ignore DEPENDENCY_NAME` "Closes the pull request and prevents Dependabot from updating this dependency."
  - `ignore DEPENDENCY_NAME major|minor|patch version` works the same way for one update level.
  - `unignore DEPENDENCY_NAME` and `unignore *` close the current PR, clear the stored conditions, and open a new PR. **[DOC]**
  - So **ignoring one member closes the whole grouped PR**. The group comes back on the next run without that member.
- **When one member fails:** the documented fix is (1) `@dependabot recreate`; (2) if it still fails, add the dependency to `exclude-patterns`, and "Dependabot will then raise a separate pull request"; (3) otherwise suspect a problem with the dependency or the ecosystem. **[DOC]** In dependabot-core's updater, a group whose update fails is marked "handled", so its members are not raised individually in that run. **[2ND]** (deepwiki walkthrough of `group_update_all_versions.rb`)

### 1.6 `multi-ecosystem-groups`

- This feature has been GA since 2025-07-01. It is a top-level `multi-ecosystem-groups:` map with its own `schedule`, and each `updates` entry joins it with `multi-ecosystem-group: NAME` plus `patterns`. It produces one PR that spans ecosystems. **[DOC]**
- **[CONFLICT]** The 2025-07-01 changelog says the feature covers security updates. The current security-updates docs say security updates are **not** grouped across ecosystems.
- **Relevance:** it is optional for us. Merging cargo and actions into one PR would save one more CI run per cycle, but it mixes risk profiles: a toolchain/action bump would land in the same PR as crate bumps, which makes bisecting harder. **Recommendation: do not use it.** Two per-ecosystem groups (at most about 2–3 PRs a week) already meet the CI-cost goal.

### 1.7 Security updates stay individual and immediate

- Groups without `applies-to` are version-only. **[DOC]** Security PRs therefore stay individual, ignore cooldown, and are raised when an advisory appears, independent of `schedule`. **[DOC]**; GitHub Blog 2026-07-29: "Security updates still open immediately".
- **Caveat [DOC]:** there is also a repo/org-level **"Grouped security updates"** toggle under Settings → Advanced Security → Dependabot. If it is enabled, security updates are grouped per ecosystem even without `applies-to: security-updates` in YAML. **[UNVERIFIED for this repo]**: someone needs to check that the toggle is **Disabled** in repo settings. I can't see it from here.
- **Caveat [DOC, troubleshooting]:** Dependabot will not open a security PR for a dependency that already has an open PR updating it. If the grouped version PR already bumps a crate to a fixed version, the fix arrives through the group PR, which then needs merging promptly.
- **Caveat [DOC]:** an `ignore` entry blocks **both** version **and** security updates for that dependency. This matters for the `dtolnay/rust-toolchain` ignore in §2.

---

## 2. Cooldown gap: branch-tracking SHA pins (dtolnay/rust-toolchain)

### 2.1 What happened

- All 7 uses in `.github/workflows/*.yml` pin `dtolnay/rust-toolchain@02cb101e...`. The trailing comment is `# stable` in 6 places and `# 1.88.0` in ci.yml's msrv job, and every use passes an explicit `with: toolchain:`. Commit `02cb101` is a **`master`** commit ("Merge pull request 185", 2026-09-12).
- `dtolnay/rust-toolchain` has **exactly one git tag, `v1`**, and the README makes no mention of any GitHub Release. **[verified on github.com/dtolnay/rust-toolchain/tags]** Toolchain selection uses branches (`stable`, `nightly`, `1.89.0`, ...) or `@master` plus a `toolchain:` input.
- The newest `master` commit is `683b588`, "1.99.1 patch release", dated 2026-10-16. This matches today's PR to a commit less than a day old. **[verified on the commits page; that this is the PR's target is TD inference]**

### 2.2 Why cooldown did not apply

- **Cooldown for GitHub Actions is based on tags and releases.**
  - dependabot-core PR #15350 (merged 2026-06-22, closes #13078) changed the date source to: GitHub Release `published_at`, then the tag's creation date, then the commit date. **[CORE]**
  - A reviewer on that PR stated: "This only applicable for version tag pinned, not applicable for commit sha pinned." **[CORE]**
  - In #13078, praseodym reported the exact symptom: an action tracked by commit hash, where "Dependabot proposes the latest `main` commit but checks cooldown against the most recent tag". In their case the commit was 4 hours old and the tag was from 2023. For us the only tag, `v1`, is very old, so any cooldown check passes trivially. **[CORE]**
- GitHub Community discussion #191178 (2026-03-31) says the same thing directly: "if you are pinning your github actions to a SHA but WITHOUT a version comment (or if that SHA doesn't correspond to a release), dependabot will ignore cooldown and will keep proposing updates using the latest commit, however recent." **[2ND]**
- Related cases:
  - #14645 ("GitHub Actions updates appear to be ignoring cooldown setting") was closed and later reopened in discussion by its reporter.
  - #13466 / PR #14349 cover hash pins following branch HEAD.
  - Open PR #15353 only adds spec tests describing moving-tag SHA cooldown behavior; it changes no production code.
  - **No dependabot-core fix exists for branch-tracked SHA pins.** **[CORE]**
- The docs only say that GitHub Actions versions resolve "from git tags", and that for git submodules Dependabot "tracks the latest commit on the configured branch. There is no version comparison". **[DOC]** Nothing in the docs promises cooldown for branch-tracked refs.

### 2.3 Can config enforce an age floor? No.

| Candidate | Works? | Why |
|---|---|---|
| `cooldown.default-days` / `include` | No | The age is computed from a tag or release date. A branch commit has neither a newer tag nor a release. |
| `semver-*-days` | No | Not supported for github-actions **[DOC]**, and a branch commit has no semver anyway. |
| `versioning-strategy` | No | Not supported for github-actions **[DOC]**. |
| `ignore` + `update-types` | No | There is no semver delta to classify between two branch commits. **[TD]**: logically follows; no doc covers it. |
| `ignore` + `versions` | No | There is no version string to match. |
| `ignore` with `dependency-name` only | Yes, as a full block | This stops all Dependabot PRs for it, **including security updates** **[DOC]**. That cost is minor here: a toolchain-installer action rarely gets advisories, and GitHub's own advisory alerts still appear in the Security tab. |

### 2.4 Realistic options (ranked)

1. **Recommended: `ignore` dtolnay/rust-toolchain and bump it manually.**
   - Add `ignore: [{dependency-name: "dtolnay/rust-toolchain"}]` to the github-actions block.
   - Bump manually (for example quarterly, or when a needed fix lands) to a `master` commit that is at least 7 days old.
   - The README says SHA pins **must be within `master`'s history**, or "will eventually get garbage-collected and your workflows will fail". Our pins already use `master` commits with explicit `toolchain:` inputs, so this works.
   - Also fix the misleading `# stable` / `# 1.88.0` comments. The pinned SHA is a `master` commit, so a comment like `# master @ 2026-09-12` is accurate. Dependabot treats a pin comment as a version hint; any effect of a non-semver hint is **[UNVERIFIED]**, and becomes moot once the action is ignored.
2. **Replace the action with plain `rustup`.**
   - For example `rustup toolchain install 1.88.0 --profile minimal --component llvm-tools-preview` followed by `rustup default 1.88.0` / `RUSTUP_TOOLCHAIN`. rustup ships on GitHub-hosted runners.
   - This removes a third-party action from 7 workflows entirely, and with it the supply-chain surface and the cooldown gap.
   - Cost: a workflow edit across 7 files. The ci-gate completeness pins in `tests/ci_gate_completeness.rs` and the msrv `RUSTUP_TOOLCHAIN` invariant (CLAUDE.md, S-626-1) must be re-reviewed.
   - **This is the strongest option for supply-chain posture.**
3. **Pin to a tag.** Not viable. The only tag is `v1`, which is ancient and never moves, so Dependabot would never propose anything.
4. **A CI age check** that fails when a pinned action SHA's commit date is under 7 days old (GitHub API lookup of the commit date). This is possible but adds a networked check to the six-file ci-gate review scope (see CLAUDE.md). There is also a timing problem: by the time CI runs on the Dependabot PR, the new action code has **already executed** in that PR's CI. Dependabot PRs get a read-only token and only Dependabot secrets, which limits the damage. Not recommended.
5. **Keep it and hold manually.** Label the PR "hold until <date+7d>". Same timing problem as option 4: the PR's own CI already runs the new commit.

---

## 3. Daily vs weekly with grouping

- **`daily` means weekdays only:** "Use `daily` to run on every weekday, Monday to Friday." **[DOC]**
- **When an open group PR exists, the scheduled run does not open a second one.**
  - The scheduled `group_update_all_versions` operation finds the existing group PR (by name and directory), logs a deferral, and skips that group. **[2ND]** (deepwiki code walkthrough; consistent with the log line "Detected existing pull request for 'minor'." quoted in dependabot-core#10492 **[CORE]**)
  - A separate **refresh** operation (`refresh_group_update_pull_request`) recomputes the group. It force-pushes the existing PR in place when the change set is equivalent. It **supersedes** the PR (closes it and opens a new one) when the set of dependencies or versions changes. **[2ND]**; #7305 documents superseding in practice **[CORE]**.
  - **[UNVERIFIED]** I could not confirm from docs exactly when the hosted service triggers a refresh, beyond rebase on conflict and comment commands. Docs do not promise that newly eligible members get added to an open group PR in place.
- **Each force-push or supersede re-runs the full CI matrix (about 24 checks, including 8 mutation shards).** Daily runs therefore keep generating CI on an open group PR as new versions finish their cooldown each weekday.
- **Recommendation: `weekly`, with a pinned `day` and `time`.**
  - Cooldown already sets a minimum latency of 7 days, so daily only shortens the extra wait from at most 7 days to at most 1 weekday. Weekly yields about 1 cargo group PR and 1 actions group PR per week, and CI runs only when those PRs change.
  - Worst-case latency becomes about 14 days (7 days of cooldown plus up to 7 days waiting for the run). That is acceptable because **security updates ignore both schedule and cooldown**. **[DOC]**
  - Pick a run time that doesn't collide with the nightly E2E at 06:00 UTC. The blog post "Tame Dependabot" (GitHub Blog, 2026-07-29) recommends grouping plus a slower cadence (it uses monthly), with the rationale "fewer interruptions; security stays fast".
- Optional extra CI savings, not proposed by default:
  - `rebase-strategy: disabled` stops automatic rebases on conflict. The cost is stale PRs that need a manual `@dependabot rebase`.
  - Leave this out unless conflict-driven rebases turn out to be a measurable share of CI cost.

---

## 4. Proposed `.github/dependabot.yml`

Design summary:
- **cargo:** two version-update groups, so that "patch + minor, but pre-1.0 minor stays individual" can be expressed.
  - `cargo-patch` takes all patch bumps.
  - `cargo-minor` takes minor bumps except for pre-1.0 crates, which are excluded by name.
  - The exact-pinned crates (`comfy-table`, `saphyr-parser`) are excluded from both groups, so each bump arrives as its own reviewed Cargo.toml diff, as their Cargo.toml comments intend.
  - Majors and pre-1.0 minors stay individual.
- **github-actions:** one group for everything, plus an ignore for `dtolnay/rust-toolchain`.
- **Security updates** are not grouped (no `applies-to: security-updates`), so they stay individual and immediate.
- **Schedule:** weekly.

```yaml
version: 2
updates:
  - package-ecosystem: "cargo"
    directory: "/"
    # Weekly, not daily. The cooldown block below is the real supply-chain
    # gate (7-day minimum soak), so daily checks only shaved <=1 weekday off
    # the wait while re-running the full CI matrix (~24 checks incl. 8
    # mutation shards) every time an open grouped PR was refreshed or
    # superseded. Weekly yields ~1 grouped PR per week. Security updates are
    # unaffected: they ignore both `schedule` and `cooldown` and open as soon
    # as an advisory is published.
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
      timezone: "Etc/UTC"
    # Counts OPEN PRs, so a grouped PR uses one slot. Security-update PRs
    # have their own fixed limit (10) and do not use these slots.
    open-pull-requests-limit: 5
    # Supply-chain hardening: wait for the upstream release to "soak" before
    # opening an update PR, so that yanked/compromised releases (e.g.
    # post-publish hijacking) age out before we surface them for review.
    # Cooldown is evaluated PER DEPENDENCY, also inside groups: a member
    # still cooling down is left out of the grouped PR, not held as a set.
    # Cooldown does NOT apply to security advisories. Dependabot still opens
    # those immediately, which is the desired behavior.
    cooldown:
      default-days: 7
      # Majors (>=1.0 crates) almost always involve API breakage. Hold them a
      # full month so the ecosystem can shake out release-day regressions
      # before we look at the diff. Matches the risk-tiered split GitHub uses
      # in its own canonical example.
      # CAVEAT: Dependabot classifies versions numerically, so a pre-1.0 bump
      # like 0.13 -> 0.14 is "minor" to Dependabot (dependabot-core#7795) even
      # though Cargo treats it as breaking. Such bumps get the 7-day minor
      # cooldown, not this 30-day one. They are kept OUT of the groups below
      # (see cargo-minor's exclude-patterns), so each still arrives as its
      # own reviewable PR.
      semver-major-days: 30
      # Minor + patch stay at the policy floor of 7 days. Patches do NOT
      # drop below this. "Patch" labels don't make a release immune to
      # post-publish hijacking; if anything the opposite is true.
      semver-minor-days: 7
      semver-patch-days: 7
    # Grouping applies to VERSION updates only (applies-to: version-updates).
    # Security updates are never grouped here and keep arriving as individual,
    # immediate PRs. (The repo-level "Grouped security updates" toggle must
    # stay Disabled for that to hold.) Groups are matched first-match-wins in
    # file order; anything matching no group (majors, pre-1.0 minors, the
    # exact-pinned crates) gets its own PR.
    groups:
      cargo-patch:
        applies-to: version-updates
        update-types: ["patch"]
        patterns: ["*"]
        # Exact-pinned crates: keep each bump as its own reviewed Cargo.toml
        # diff, which is the stated reason they are exact-pinned (see the
        # Cargo.toml comments; issue #626 / ADR-0025, S-CIGATE-3 / AC-006).
        # saphyr-parser is 0.0.x, where Dependabot's "patch" can be breaking.
        exclude-patterns:
          - "comfy-table"
          - "saphyr-parser"
      cargo-minor:
        applies-to: version-updates
        update-types: ["minor"]
        patterns: ["*"]
        # Pre-1.0 crates: a Dependabot "minor" (0.x -> 0.(x+1)) is a Cargo
        # semver-MAJOR (breaking) change, so these must stay ungrouped. Their
        # 0.x.y patch bumps are still grouped by cargo-patch above.
        # MAINTENANCE: add any new pre-1.0 direct dependency here. Remove a
        # crate once it reaches 1.0.
        exclude-patterns:
          - "comfy-table"
          - "saphyr-parser"
          - "base64"
          - "chrono"
          - "dialoguer"
          - "figment"
          - "futures"
          - "glob"
          - "libc"
          - "pulldown-cmark"
          - "rand"
          - "reqwest"
          - "sha1"
          - "temp-env"
          - "tokio-util"
          - "tracing"
          - "tracing-subscriber"
          - "windows-sys"
          - "wiremock"

  - package-ecosystem: "github-actions"
    directory: "/"
    # Same weekly cadence + cooldown rationale as the cargo block above.
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
      timezone: "Etc/UTC"
    open-pull-requests-limit: 5
    # GitHub Actions doesn't follow strict semver, so only default-days is
    # honored here per the Dependabot options reference. Cooldown age comes
    # from the GitHub Release publish date, then the tag date, then the
    # commit date (dependabot-core PR #15350). It is NOT enforced for SHA
    # pins that track a branch rather than a tag (see the ignore below).
    cooldown:
      default-days: 7
    # One grouped PR for all action version updates (security updates are
    # not grouped; see the cargo block comment).
    groups:
      github-actions:
        applies-to: version-updates
        patterns: ["*"]
    ignore:
      # dtolnay/rust-toolchain publishes no releases and only a single,
      # ancient "v1" tag; it is consumed as a SHA on the master branch with an
      # explicit `toolchain:` input. Dependabot proposes master's newest
      # commit and evaluates cooldown against the old tag, so `cooldown` is a
      # no-op for it (dependabot-core#13078 / PR #15350 review; community
      # discussion #191178). It opened a PR to a <1-day-old commit despite
      # default-days: 7. Bump it MANUALLY, to a master commit at least 7 days
      # old (the README requires SHAs within master's history, or they get
      # garbage-collected). Note this ignore also suppresses Dependabot
      # SECURITY PRs for this action; accepted, since advisories still show
      # in the Security tab.
      - dependency-name: "dtolnay/rust-toolchain"
```

**Before merging:**
- Run the YAML through GitHub's validator. The Insights → Dependency graph → Dependabot tab shows config errors after push.
- Confirm "Grouped security updates" is Disabled in repo settings.
- After the ignore lands, close the open dtolnay/rust-toolchain PR (or comment `@dependabot ignore dtolnay/rust-toolchain`).
- Decide separately on option 2 (replace the action with `rustup`).

---

## Sources

- Dependabot options reference: https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference
- Optimizing PR creation (groups, applies-to, update-types examples): https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/optimizing-pr-creation-version-updates
- PR comment commands (grouped ignore/unignore, rebase/recreate): https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-pull-request-comment-commands
- Dependabot errors (group member failure, `recreate`, `exclude-patterns`; separate security PR limit): https://docs.github.com/en/code-security/reference/supply-chain-security/troubleshoot-dependabot/dependabot-errors
- Configure security updates (Grouped security updates toggle, first-match rule): https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configure-security-updates
- Security updates concept (no cross-ecosystem security grouping): https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-security-updates
- Multi-ecosystem updates: https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-multi-ecosystem-updates ; changelog https://github.blog/changelog/2025-07-01-single-pull-request-for-dependabot-multi-ecosystem-support/
- Ignore suppresses security updates too: https://docs.github.com/en/code-security/reference/supply-chain-security/troubleshoot-dependabot/vulnerability-detection
- Default 3-day cooldown changelog (2026-07-14): https://github.blog/changelog/2026-07-14-dependabot-version-updates-introduce-default-package-cooldown/ ; discussion https://github.com/dependabot/dependabot-core/discussions/15582
- GitHub Blog "Tame Dependabot" (2026-07-29): https://github.blog/security/supply-chain-security/tame-dependabot-group-your-updates-slow-the-cadence-keep-security-fast/
- dependabot-core#7795 (pre-1.0 classified as minor): https://github.com/dependabot/dependabot-core/issues/7795
- dependabot-core#13078 (cooldown uses tag/commit date; branch-tracked SHA checked against old tag): https://github.com/dependabot/dependabot-core/issues/13078
- dependabot-core PR #15350 (release > tag > commit date; "not applicable for commit sha pinned"): https://github.com/dependabot/dependabot-core/pull/15350
- dependabot-core PR #15353 (characterization tests, open): https://github.com/dependabot/dependabot-core/pull/15353
- dependabot-core#14645 (GHA cooldown ignored): https://github.com/dependabot/dependabot-core/issues/14645
- dependabot-core#13466 / PR #14349 (hash pins following branch commits): https://github.com/dependabot/dependabot-core/issues/13466 , https://github.com/dependabot/dependabot-core/pull/14349
- dependabot-core#14683 (transitive deps escape cooldown in grouped npm updates): https://github.com/dependabot/dependabot-core/issues/14683
- dependabot-core#10492, #7305 (existing group PR detection / superseding): https://github.com/dependabot/dependabot-core/issues/10492 , https://github.com/dependabot/dependabot-core/issues/7305
- Community discussion #191178 (SHA not bound to a release → cooldown ignored): https://github.com/orgs/community/discussions/191178
- deepwiki dependabot-core groups/operations (secondary, generated): https://deepwiki.com/dependabot/dependabot-core/2.4-dependency-groups-and-update-operations
- dtolnay/rust-toolchain repo / tags / master commits: https://github.com/dtolnay/rust-toolchain , https://github.com/dtolnay/rust-toolchain/tags , https://github.com/dtolnay/rust-toolchain/commits/master

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 (1 timed out at 300s) | Group, cooldown, limit and command semantics sweep. The second call (branch-SHA cooldown) timed out and was replaced by targeted ask/search plus WebFetch of primary sources. |
| Perplexity perplexity_reason | 0 | not needed |
| Perplexity perplexity_search | 2 | Branch-SHA cooldown issues; group refresh/supersede code path |
| Perplexity perplexity_ask | 3 | Issue lookup (#14645/#13466); Cargo 0.x classification (answer self-contradictory, discarded); ignore vs security updates |
| Context7 | 0 | Not a library-API question |
| Tavily | 0 | Not available or needed; WebFetch used for primary-source extraction |
| WebFetch | 15 | docs.github.com (options ref x2, optimizing, commands, security config); dependabot-core #14645, #13466, #13078, #7795, PRs #15350, #14349, #15353; GitHub Blog; dtolnay repo, tags, commit, master log |
| WebSearch | 0 | n/a |
| Training data | 2 areas | Inference that `ignore` + `update-types` cannot apply to branch commits; inference that today's PR targets `683b588` |

**Total MCP tool calls:** 7
**Training data reliance:** low. Every load-bearing claim is cited to docs.github.com or dependabot-core. The exact refresh-job trigger cadence and the cooldown classifier for pre-1.0 versions are flagged [UNVERIFIED].
