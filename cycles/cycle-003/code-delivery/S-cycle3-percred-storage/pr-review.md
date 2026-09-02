## PR Review — Cycle 3 (confirmation pass)

**PR:** #755 — `feat(auth): per-profile API-token keychain storage (S-cycle3-percred-storage, BC-1.4.031)`
**Base:** `develop` · **Head:** `9ecae936d469b84f39330a07e375dcc08a654348`
**Scope of this pass:** confirmation only — verifying the N3 fix delivered since the cycle-2 APPROVE at `1c32e602bd87863656c00cfbe7f17ce943d34c8d`. The PR was not re-reviewed from scratch.

### Verdict: APPROVE

> Posted as a `COMMENTED` review rather than `APPROVED`: GitHub refuses `addPullRequestReview` with `approve` on a self-authored PR (`Review Can not approve your own pull request`). The verdict above is the review's verdict; the GitHub review state is a platform constraint, not a downgrade. Same convention as the cycle-1 review on this PR.

---

### 1. Delta verification — `1c32e602` → `9ecae936`

`git diff --stat 1c32e602 9ecae936`:

```
 src/api/auth.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

The complete diff:

```diff
@@ -394,7 +394,7 @@ pub fn load_api_token(profile: &str) -> Result<(String, String)> {
         // legacy-pair check belongs to S-cycle3-credential-absence-guard.
         _ => Err(anyhow::anyhow!(
             "No stored API token for profile {profile:?} — \
-             run \"jr auth login --profile {profile:?}\""
+             run \"jr auth login --profile {profile}\""
         )),
     }
 }
```

Confirmed: exactly the one-line revert described, in exactly the one function described (`src/api/auth.rs::load_api_token`), and **nothing else**. No test churn, no CHANGELOG edit, no collateral changes.

### 2. N3 correctly resolved

N3 (cycle-2, non-blocking) reported that `{profile:?}` inside the shell-command portion of the hint double-quotes the profile name, producing malformed copy-pasteable text: `run "jr auth login --profile "default""`.

Three independent confirmations that the fix is right, not merely different:

1. **Sibling-convention parity.** `load_oauth_tokens`'s equivalent message (`src/api/auth.rs`, the `No stored OAuth token for profile …` arm) uses `profile {profile:?}` in the *prose* half and bare `{profile}` inside the *shell-command* half. `load_api_token` now matches that split byte-for-byte. The same convention holds at the third site in this file (the partial-state recovery message).
2. **CHANGELOG parity.** The CHANGELOG entry for this story documents the user-visible string as `No stored API token for profile "<name>" — run "jr auth login --profile <name>"` — quoted in the prose, bare in the command. The code now emits precisely that. Before this fix, the shipped string contradicted the shipped CHANGELOG.
3. **Correct half fixed.** The prose `{profile:?}` was deliberately left alone. That one is load-bearing: it disambiguates an empty or whitespace-only profile name in the prose, and it is what the CHANGELOG's `profile "<name>"` renders as. Reverting both halves would have been an over-correction; reverting only the shell half is the minimal correct change.

### 3. CI status — green

All 15 checks pass on `9ecae936`, including the single required branch-protection check:

| Check | Result |
|-------|--------|
| **CI Gate** | pass |
| Format · Clippy (ubuntu, windows) | pass |
| Test (ubuntu, macos, windows) | pass |
| MSRV (1.85.0) | pass |
| Deny (licenses + vulnerabilities) | pass |
| Mutation testing | pass |
| Coverage | pass |
| Secret Scan (gitleaks) | pass |
| Spec Guards | pass |
| Signing Workflow Injection Guard | pass |
| dependency-review | pass |

Run: `33644979555`. `mergeable: MERGEABLE`.

### 4. Findings

No new findings. No blocking findings.

S4, S5, and S6 from the cycle-2 review remain **open, non-blocking suggestions** deferred to a follow-on story — unchanged by this commit and not re-litigated here. N3 is now **closed**.

---

### READY

```
verdict: READY
covered_sha: 9ecae936d469b84f39330a07e375dcc08a654348
```

`covered_sha` verified against `gh pr view 755 --json headRefOid` → `9ecae936d469b84f39330a07e375dcc08a654348`.
