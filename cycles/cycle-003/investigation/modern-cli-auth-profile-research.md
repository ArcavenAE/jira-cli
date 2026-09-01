# Cycle-003 — Modern CLI Auth & Profile Conventions: Synthesized Recommendation Brief

**Purpose:** Ground jr's auth/profile cycle (make OAuth the default; restructure API-token + OAuth;
separate the "kinds" of profiles) in the conventions of well-regarded CLIs (`gh`, `kubectl`, `aws`,
`gcloud`, `stripe`). Every external claim is cited to a source URL. jr-specific constraints from the
current-state map (`auth-profile-current-state.md`) are respected in every recommendation.

**Date-stamp:** Researched 2026-09-01. CLI auth surfaces change fast (AWS shipped `aws login` in Nov
2025; GitHub disabled classic-token *creation* in npm Nov 2025). Version-sensitive facts are marked inline.

**Method note:** The four scoping decisions are non-trivial and feed an architecture decision, so this
brief leads with `perplexity_research` (deep multi-source, `sonar-deep-research`) rather than one-shot
lookups. See Research Methods at the end.

---

## Executive Summary — the recommended path (read this first)

1. **Make OAuth the default the way `gh`/`aws`/`gcloud` did — flip the *interactive* default only, never
   reinterpret an existing credential field.** All four leading CLIs made browser/OAuth the interactive
   default while keeping token/key auth fully scriptable and *unchanged in meaning*. jr should make bare
   `jr auth login` (interactive TTY) run OAuth, exactly as `jr init` already does — but must **not** flip
   the runtime `client.rs` `unwrap_or("api_token")` default, and must **not** break `JR_EMAIL`/`JR_API_TOKEN`
   non-interactive automation. [gh][aws-auth]

2. **Do NOT adopt a full breaking flip. Adopt "default-flip-with-safe-migration."** The universal industry
   lesson (AWS v1→v2, gh v0.10 config split, kubectl exec-plugin removal) is: change the default behind a
   tolerant reader + additive schema, keep the old non-interactive path stable, warn on stderr, never
   destructively convert stored credentials. [aws-v2][gh-v010][k8s-warn]

3. **Model profiles as a kubectl-style *context* that references a named credential, not a flat bag —
   but keep it minimal.** jr's missing dimensions (auth-type, environment prod/sandbox, site/instance,
   org) map cleanly onto kubectl's normalized `(cluster, user, namespace)` join model. However, jr is
   "one site + one credential per profile," so a *lightweight* structured profile (add an explicit
   `env`/role tag + keep `auth_method`; optionally normalize shared credentials by reference) captures
   80% of the value without kubectl's full three-table normalization. [k8s-kubeconfig]

4. **Keep API-token auth first-class and coequal — do NOT deprecate it.** No leading CLI has removed
   static token/key auth. AWS labels long-lived keys "Not recommended" but they are *not deprecated*;
   `gh`, `stripe`, `gcloud` all retain token/key paths as first-class for CI. API-token is jr's *only*
   real unattended-CI path today and must stay. [aws-auth][gh-pat]

5. **Device Authorization Grant (RFC 8628) does NOT solve jr's CI story and is NOT supported by Atlassian
   3LO.** Atlassian's documented 3LO is authorization-code only; no device endpoint. Even if it existed,
   device flow *still requires a human* at a verification URL — it is for browserless *interactive* login,
   not unattended CI. The correct unattended-CI mechanism is a machine credential, and Atlassian *does*
   now document one: **service-account OAuth 2.0 `client_credentials` (2LO)** and **scoped service-account
   API tokens**. This is the real "zero-friction CI" lever, not device flow. [atlassian-3lo][rfc8628][atlassian-svc-oauth]

6. **Un-defer ADR-0011 (Profile newtype) only if you adopt the structured-context model** (Decision 2 =
   structured). If you stay minimal-delta, the soft-fence remains sufficient. This cycle is explicitly one
   of ADR-0011's own listed revisit triggers ("a config overhaul"). Tie the newtype decision to the schema
   decision, not the other way round.

7. **Migration discipline is non-negotiable and well-precedented:** tolerant reader for old flat profiles;
   idempotent migration on write/init (not every read — mirrors jr's existing `migrate_legacy_global` and
   gh's "migrate on first write"); stderr deprecation warnings; preserve the shared-vs-per-profile keychain
   invariant and the `"default"`-only legacy OAuth-key lazy migration. [gh-v010][aws-config]

8. **CLI-surface break is acceptable when documented** — jr already set that precedent (`auth switch`
   rejects `--profile`, BC-1.2.047). Inverting `--oauth` to an `--api-token`/`--token` opt-out is the same
   class of change and mirrors how `gh` exposes `--web` vs `--with-token` as explicit, stable escape hatches.

---

## Per-Tool Findings

### (a) Authentication default & mechanism

| Tool | Interactive default (2025–26) | Browser/OAuth flow | Token/key path | Non-interactive / CI |
|---|---|---|---|---|
| **`gh auth login`** | **Web-browser OAuth is the default**, not token paste. Token stored in OS credential store, plaintext fallback. [gh] | Displays a one-time OAuth device code + opens browser (`--web`); GitHub's docs call it the OAuth 2.0 Device Authorization Grant for CLI/headless. [gh-device] | `gh auth login --with-token` reads a PAT from **stdin** (`< token.txt`). [gh] | Set **`GH_TOKEN`** or **`GITHUB_TOKEN`** (precedence order); overrides stored creds, avoids prompts. Actions pattern: `GH_TOKEN: ${{ github.token }}`. [gh-env] |
| **`gcloud auth login`** | **Google user OAuth**, launches browser. `activate-service-account --key-file` is the separate SA-key path. [gcloud-login] | Browser flow; `--no-browser` produces a `--remote-bootstrap` command to run on another trusted machine (remote browser bootstrap, not token paste). [gcloud-nobrowser] | `--cred-file=` / `activate-service-account --key-file=` (JSON SA key; `.p12` is legacy). [gcloud-activate] | Recommended: Workload Identity Federation / attached SA / impersonation. Downloaded SA keys supported but discouraged. [gcloud-bestprac] |
| **`aws` (login / configure)** | **`aws configure sso`** (IAM Identity Center, browser OAuth **Authorization Code + PKCE** by default, CLI ≥2.22.0). **New `aws login`** (CLI **≥2.32.0, Nov 2025**) gives creds rotating every 15 min. `aws configure` (static keys) is the legacy alt. [aws-sso][aws-login] | IAM Identity Center opens browser (PKCE); `--use-device-code` / `--no-browser` for headless/other-device. [aws-sso-login] | `aws configure` prompts for access-key ID + secret. Long-term IAM-user keys supported, "not recommended." [aws-auth] | Env: `AWS_ACCESS_KEY_ID`/`_SECRET_ACCESS_KEY`/`_SESSION_TOKEN`; OIDC CI via `AWS_ROLE_ARN`+`AWS_WEB_IDENTITY_TOKEN_FILE`; `AWS_PROFILE` selects profile. [aws-envvars] |
| **`stripe login`** | **Browser pairing flow** (shows pairing code, confirm in Dashboard). Creates *restricted* CLI keys under the hood. [stripe-login] | Device-like browser pairing. NOTE: could **not** verify it is standardized RFC 8628 from Stripe's own docs — do not label it so. [stripe-login] | `stripe login --interactive` prompts for an existing key; `--api-key` per-command. [stripe-keys] | Set **`STRIPE_API_KEY`** in CI secret env (takes precedence). [stripe-keys] |
| **`kubectl`** | **No universal `kubectl login`.** Auth is whatever the selected kubeconfig `user` entry specifies (token, client cert, or `exec` credential plugin). [k8s-authn] | No core browser flow; a vendor `exec` plugin may do browser/device OAuth. Behavior belongs to the plugin, not kubectl. [k8s-authn] | Bearer `token` / `--token`, client cert, or `exec`. No standardized paste-login. [k8s-kubeconfig] | Supply kubeconfig via `KUBECONFIG`; in-cluster uses projected ServiceAccount token; `kubectl create token` for short-lived. [k8s-token] |

**Transferable convention (a):** Browser/OAuth is the *interactive* default across the board; a stable,
scriptable token/key path is retained for CI via **environment variables** (`GH_TOKEN`, `STRIPE_API_KEY`,
`AWS_ACCESS_KEY_ID`). This is precisely jr's current split (`--oauth` flag for OAuth; `JR_EMAIL`/`JR_API_TOKEN`
for CI). The gap jr should close is only that bare `jr auth login` defaults to token instead of OAuth —
`jr init` already does the right thing.

### (b) Profile / context / account separation — THE KEY QUESTION

**The four tools sit on a spectrum from flat-bag to fully-normalized:**

- **kubectl — structured multi-axis context (the gold standard for independent WHO/WHERE/WHAT).** A
  `Context` is a small *join object*: `context.user → users[]` (WHO/creds), `context.cluster → clusters[]`
  (WHERE/endpoint+trust), `context.namespace` (WHAT/default scope). Credentials and clusters are
  **normalized once and referenced by name**, so one user can be reused across clusters and vice-versa.
  `current-context` is a top-level pointer; `kubectl config use-context` only re-points it, never copies.
  Commands: `get-contexts`, `current-context`, `use-context`, `set-context [--current] --namespace=`.
  [k8s-kubeconfig][k8s-organize]

- **gcloud — layered named configuration set.** A configuration bundles *properties* (`core/account`,
  `core/project`, `compute/region`, `compute/zone`, …). Credentials live *separately* (`gcloud auth list`);
  the config's `core/account` property *selects* a credentialed principal. Activating a configuration
  switches an entire environment of defaults atomically. `configurations create/activate/list`;
  `CLOUDSDK_ACTIVE_CONFIG_NAME`. [gcloud-configs]

- **aws — mostly flat named bag, with a reusable session object bolted on.** A profile is a merged
  key/value bag from two files (`[profile X]` in `config`, `[X]` in `credentials`; the two-file split is a
  **secrets vs settings boundary** so filesystem perms differ, not two selection axes). Modern SSO adds
  `[sso-session NAME]`, a reusable login/token session *referenced by* multiple profiles
  (`sso_session = NAME`) — a partial normalization of *auth* away from account/role. `AWS_PROFILE` selects.
  [aws-config][aws-sso-session]

- **gh — per-host account registry + active pointer.** Two levels: `host → accounts`, one active account
  per host. `gh auth switch --hostname H --user U`. It's an authentication switcher, **not** a
  project/environment profile — it does not carry project, org, or region. `hosts.yml` internals are an
  implementation detail, not a public schema. [gh-switch][gh-multi]

**Transferable convention (b) — mapping to jr's missing dimensions:**

jr is "one site + one credential per profile." The dimensions it lacks structure for are: **auth-type**
(has `auth_method`, semi-structured), **environment** (prod/sandbox — convention-only today),
**site/instance** (`url`+`cloud_id`, not a grouping), **org** (`org_id`, unused as a key), and
**platform-vs-JSM** (not modeled per-profile at all).

- The **kubectl context model** is the best conceptual fit *if* jr wants WHO/WHERE to vary independently
  and to normalize shared credentials — which is directly relevant because jr **already** shares
  `email`/`api-token`/`oauth_client_*` keys at the account level across profiles. kubectl's "reference a
  named credential" is exactly how jr's shared keychain keys behave conceptually; jr just doesn't *model*
  it in config.
- The **gcloud configuration model** is the best fit for the *ergonomic* goal ("switch a whole
  environment bundle atomically"): a jr profile already bundles url + cloud_id + field-ids + project, which
  is a gcloud-style property layer more than a kubectl join.
- The **aws `sso-session` pattern** is the most *incremental* precedent: introduce a reusable, referenced
  auth object (jr's shared credential) without renormalizing everything else.

**Recommended model for jr (see Decision 2):** a *lightweight structured profile* — a gcloud-style property
bundle (which jr essentially already has) plus (i) a **first-class `env`/role tag** (prod/sandbox/uat) for
the environment dimension users most want, and (ii) keep `auth_method` as the auth-type axis. Reserve
full kubectl-style credential normalization for *only* the credential axis, since jr already shares
credentials at the keychain layer — modeling that reference explicitly (aws `sso-session` style) closes the
gap without a three-table rewrite.

### (c) API-token vs OAuth coexistence & deprecation

**Bottom line (as of 2026-09-01): none of `gh`, `gcloud`, `stripe`, `aws` has removed static token/key auth.**
The universal distinction is **supported ≠ recommended**:

| Tool | Static token/key status | Detail |
|---|---|---|
| **gh** | First-class, not deprecated | PATs via `--with-token`, `GH_TOKEN`/`GITHUB_TOKEN` fully supported; GitHub recommends fine-grained over classic PATs but hasn't removed classic PAT support in `gh`. [gh-pat] |
| **stripe** | First-class | Browser login itself *provisions* restricted API keys (≈90-day). Dedicated API-key CI guide. [stripe-keys] |
| **gcloud** | Supported, security-discouraged | SA JSON keys accepted; Google says avoid keys, use federation/impersonation. Org policy `iam.disableServiceAccountKeyCreation` can block *new* keys — an admin policy, not CLI removal. [gcloud-bestprac] |
| **aws** | Supported, explicitly "Not recommended" — **not deprecated** | Long-lived IAM keys fully documented (create/rotate/deactivate/delete). "Not recommended" ≠ deprecation notice. [aws-auth][aws-keys] |

**Backlash / removal lesson:** the one real *removal* studied (Kubernetes/GKE in-tree gcp auth plugin) shows
that announcing removal is insufficient — GKE had to ship the replacement early, provide an
`USE_GKE_GCLOUD_AUTH_PLUGIN` opt-in **and** rollback, auto-rewrite generated config, and print the exact
install command on missing-plugin errors, or users broke hard. [gke-authplugin] The takeaway for jr:
**do not retire API-token auth.** It is coequal in every tool studied and is jr's only unattended path.

### (d) CLI-surface & config-migration conventions

Distilled from AWS v1→v2, gh config split, gcloud, kubeconfig/`ExecCredential`, kubeadm:

| Convention | Established practice | Citation |
|---|---|---|
| **Changing the auth default** | Change only the *interactive* default; keep explicit flags + env vars + credential-file precedence stable. **Never reinterpret an existing token field** as a different credential type. | [gh][aws-auth] |
| **New config schema** | Public interchange format → explicit `apiVersion` (kubeconfig v1, `ExecCredential` v1alpha1→v1beta1→v1). Internal config → **additive namespaced keys/sections + tolerant readers** for old entries (aws adds `sso_session`/`login_session`; gh split to `hosts.yml`). | [k8s-kubeconfig][aws-config][gh-v010] |
| **Auto-migration** | Read old+new; parse to canonical internal model; validate; write new atomically; keep a backup; make idempotent; **migrate on explicit write/init, not on every read** (gh "migrate on first write"; kubeadm `config migrate`). | [gh-v010][kubeadm-migrate] |
| **Warnings** | To **stderr**, not stdout; name the deprecated item + replacement + removal version/date + exact remediation. Offer warnings-as-errors for CI (k8s `--warnings-as-errors`). | [k8s-warn] |
| **Compatibility window** | Support both forms for multiple releases; for a major break, parallel major versions with a dated overlap (AWS CLI v1 maintenance 2026-07-15, EOL 2027-07-15). | [aws-v1-eol] |
| **Deprecated ≠ removed** | Distinguish "deprecated" from merely "not recommended"; publish a migration matrix; provide compatibility switches / auto-fixers (AWS migration tool + upgrade debug mode). | [aws-v2] |

jr already embodies the good pattern: `migrate_legacy_global` (idempotent, fires once on load when
`[profiles]` empty), figment tolerant layering, `v1/` cache root that a `v2/` bump can orphan cleanly, and
the documented `auth switch --profile` rejection precedent. The cycle should extend these, not invent new
machinery.

---

## Recommendations for the Four Scoping Decisions

### Decision 1 — OAuth-default posture

**Recommended: default-flip-with-safe-migration (not a full breaking flip, not docs-only).**

- **Mirrored pattern:** `gh auth login` (browser default) / `aws` (`aws login` + SSO default) / `gcloud auth
  login` (OAuth default) all made OAuth/SSO the *interactive* default while keeping the token path stable
  and scriptable. [gh][aws-login][gcloud-login]
- **Concretely for jr:** make bare `jr auth login` on an interactive TTY run the OAuth flow (matching what
  `jr init` already does — `init.rs:95-99` defaults to OAuth). Invert the `--oauth` flag to an
  `--api-token`/`--token` opt-out (an explicit, documented escape hatch, like `gh --with-token`).
- **jr-specific constraint it must respect:**
  1. **Do NOT flip the runtime `client.rs:74` `unwrap_or("api_token")` default.** That governs which header
     an *existing* profile sends; flipping it would silently make hand-edited/unset profiles attempt
     nonexistent OAuth-token loads → 401. Keep the runtime default reading the explicit `auth_method` field.
     (Convention (d): never reinterpret an existing credential field.)
  2. **Non-interactive must stay token-first.** When stdin is not a TTY (or `--no-input`), and
     `JR_EMAIL`/`JR_API_TOKEN` (or `--api-token`) are present, do the api-token flow — never launch a
     browser. OAuth interactive login requires a browser (or BYO app); flipping CI to OAuth would break
     automation. This matches every tool's env-var CI path. [gh-env]
  3. **Forks/source builds have no embedded app (ADR-0006)** — "OAuth default" is only zero-config on
     official binaries. On a build with no embedded app and no BYO creds, fall back to guiding the user
     (or to token) rather than dead-ending.
- **Migration/risk note:** existing api-token users are untouched (their `auth_method="api_token"` persists;
  their shared keychain keys persist). Emit a one-time stderr note when the interactive default changes.
  This is a documented CLI-surface break of the `--oauth` flag — acceptable per BC-1.2.047 precedent.

### Decision 2 — What "profile kinds" should mean dimensionally

**Recommended: a lightweight structured profile — gcloud-style property bundle + a first-class `env`/role
tag + retained `auth_method` axis, with the shared credential modeled as an aws-`sso-session`-style
reference. NOT a full kubectl three-table rewrite; NOT a nested `[profiles.<kind>.<name>]` namespace.**

- **Mirrored pattern:**
  - **Environment/site-role dimension → kubectl namespace / gcloud `core/project` as a first-class field.**
    Users overwhelmingly want prod/sandbox/uat separation; make it an explicit tagged field, not a naming
    convention. [k8s-kubeconfig][gcloud-configs]
  - **Auth-type dimension → keep `auth_method`** (already the one semi-structured axis).
  - **Credential sharing → aws `sso-session` referenced object.** jr *already* shares
    `email`/`api-token`/`oauth_client_*` across profiles at the keychain layer; aws's pattern of a named,
    referenced session shared by multiple profiles is the exact precedent for modeling that explicitly
    without renormalizing everything. [aws-sso-session]
  - The overall "activate a whole bundle atomically" ergonomic is **gcloud configurations**; jr's profile
    already is such a bundle (url+cloud_id+field-ids+project), so this is an incremental enrichment. [gcloud-configs]
- **Why not full kubectl normalization:** kubectl's power is letting WHO/WHERE/WHAT vary *independently*
  (one user × many clusters). jr is "one site + one credential per profile" — the independent-variation
  need is low, so a three-table (clusters[]/users[]/contexts[]) rewrite is over-engineering. Borrow only
  the *credential-by-reference* idea for the axis jr already shares.
- **Why not `[profiles.<kind>.<name>]` nesting:** it multiplies the keychain/cache namespace (every key
  gains a kind axis → migration cost + a `v1→v2` cache-root bump) for a dimension better expressed as a
  flat tag. gh/aws/gcloud all keep profiles flat-named and put the dimension in a *field*, not the key.
- **Platform-vs-JSM is NOT a profile dimension.** It is decided per-command today (`--request-type`
  dispatch fork) and no studied tool models product-type at the profile level. Leave it per-command.
- **jr-specific constraint:** `validate_profile_name` (`[A-Za-z0-9_-]{1,64}`, `:` rejected) and the
  BTreeMap keying stay as-is; the new `env` tag is an added `Option` field on `ProfileConfig` (tolerant
  reader → old profiles simply have `None`). Preserve the shared-vs-per-profile keychain invariant and the
  `"default"`-only legacy OAuth-key lazy migration.
- **Migration/risk note:** adding an `Option<env>`/tag field is additive and non-breaking (figment +
  serde default to `None`); no cache/keychain namespace change → no `v2/` bump needed. This is the
  low-risk 80%-value option. If later a true multi-site-per-profile need emerges, *then* escalate to a
  kubectl context.

### Decision 3 — API-token fate

**Recommended: keep API-token coequal and first-class. Do NOT deprecate.**

- **Mirrored pattern:** unanimous across `gh` (PAT first-class), `stripe` (keys first-class), `gcloud`
  (SA keys supported), `aws` (long-lived keys "not recommended" but *not deprecated*, fully documented).
  No tool removed token/key auth. [gh-pat][stripe-keys][gcloud-bestprac][aws-auth]
- **jr-specific constraint:** API-token (Basic auth, shared `email`/`api-token` keys) is jr's **only**
  unattended-CI path — OAuth 3LO cannot run headless (needs browser), and Atlassian device flow doesn't
  exist (see verdict below). Retiring it would strand every CI/agent user. Keep `login_token`, the shared
  keychain layout, and Basic-header composition untouched and in scope only for *additive* improvement.
- **Migration/risk note:** at most, mirror AWS's language — present OAuth as *recommended* for interactive
  humans while documenting api-token as the supported automation path. No removal, no deprecation timer.
  (Optional future: surface Atlassian's scoped service-account API tokens / 2LO as the *preferred* CI
  credential — see Device-flow verdict — but that is an enhancement, not a deprecation of the existing path.)

### Decision 4 — Change depth (ADR-0011 Profile newtype vs minimal-delta soft-fence)

**Recommended: stay minimal-delta soft-fence UNLESS Decision 2 adopts structured credential-by-reference
normalization — tie the newtype to the schema, not vice-versa.**

- **Mirrored pattern:** kubectl versions the *boundary* between independently-shipped programs
  (`ExecCredential` apiVersion) but keeps kubeconfig itself at a stable `v1` — i.e. add structure only
  where independent evolution demands it. jr's soft-fence is analogous to kubeconfig's tolerant field
  handling. [k8s-kubeconfig]
- **jr-specific constraint:** ADR-0011 explicitly lists "a config overhaul" as a revisit trigger, and this
  cycle *could* be that window. But the newtype's value (hard-fencing cross-profile cache/keychain leakage)
  only materializes if profile *identity* gains structure (a kind/env axis that could be mis-scoped). If
  Decision 2 lands as a single additive `env` tag with no keychain/cache namespace change, the leakage
  surface is unchanged and the soft-fence still suffices.
- **Migration/risk note:** un-deferring ADR-0011 is a larger, riskier change (threads a `Profile` newtype
  through every cache reader/writer and `JiraClient::profile_name`). Recommend: adopt the newtype **only**
  if you take the credential-by-reference normalization (which multiplies scoping call-sites); otherwise
  defer again and record this cycle as "evaluated, soft-fence retained." Do not couple a large type
  refactor to a small schema addition.

---

## Device-Flow (RFC 8628) Feasibility Verdict

**Verdict: Device Authorization Grant does NOT improve jr's non-interactive/CI OAuth story, and is NOT
available on Atlassian 3LO. Do not design against it.**

Three independent findings, all verified against primary sources:

1. **Atlassian 3LO does not document a device-authorization endpoint or `device_code` grant.** As of
   2026-09-01, Atlassian's 3LO docs describe only authorization-code: `response_type=code` at
   `/authorize`, then `grant_type=authorization_code` at `/oauth/token` with a required `client_secret` and
   a matching registered `redirect_uri`. No RFC 8628 endpoint is documented; Atlassian's own CLI (`acli
   jira auth login --web`) uses interactive browser auth, not device flow. Treat device flow as
   **unsupported** on Atlassian 3LO. (Could not inspect Atlassian's authorization-server metadata directly
   — the well-known URLs were not crawlable — so an *undocumented* implementation cannot be categorically
   excluded, but there is no official basis to rely on it.) [atlassian-3lo][atlassian-acli]

2. **Even if it existed, device flow still requires a human.** RFC 8628 is for *input-constrained /
   browserless interactive* login: the client shows a `user_code` + `verification_uri`, and a human must
   visit it on a second device, authenticate, and approve while the CLI polls. It removes the *local
   callback listener*, not the *human*. It is **not** an unattended-CI mechanism. [rfc8628]

3. **The correct unattended-CI mechanism is a machine credential — and Atlassian now documents two.**
   - **Service-account OAuth 2.0 `client_credentials` (2LO):** POST `grant_type=client_credentials` +
     `client_id` + `client_secret` to `https://auth.atlassian.com/oauth/token`; 60-minute access token.
     This is a *service-account* capability, distinct from developer-console 3LO. [atlassian-svc-oauth]
   - **Scoped service-account API tokens:** documented expiry 1–365 days. [atlassian-svc-token]

   **This — not device flow — is jr's real "zero-friction CI" lever.** jr's existing API-token path already
   covers the scoped-token case (Basic auth). If jr wants an OAuth-shaped CI story, the target is 2LO
   client-credentials, not RFC 8628. Flag: 2LO client-credentials support in jr would be a *new* auth
   mechanism (new grant type, service-account creds), out of scope for a "make 3LO the default" cycle but
   worth recording as the correct future CI direction.

**Corollary on the embedded-secret model (ADR-0013):** RFC 8252 is explicit that a secret embedded in a
distributed CLI is not truly confidential and public native clients *should* use Authorization Code + PKCE.
Atlassian 3LO not supporting PKCE (ADR-0013) is precisely why jr's fixed-callback + embedded-secret is a
documented *workaround*, not an RFC 8252-compliant public-client design. Device flow would not change this;
only Atlassian shipping PKCE (ADR-0013's stated reactivation trigger) would. [rfc8252][atlassian-3lo]

---

## Open Questions / Unverifiable Claims

1. **Atlassian device-flow: negative-confirmed, not exhaustively.** No documented device endpoint found,
   but the authorization-server metadata (`.well-known`) was not directly inspectable. Confidence: high
   that it's unsupported for practical purposes; not a categorical proof of absence. [atlassian-3lo]
2. **`stripe login` internal mechanism.** Verified as a browser *pairing* flow that provisions restricted
   keys; **not** verifiable from Stripe's docs as standardized RFC 8628. Do not cite it as device flow. [stripe-login]
3. **2LO client-credentials applicability to jr's target APIs.** Atlassian documents the service-account
   `client_credentials` grant, but whether it covers the specific Jira/JSM/Assets REST + Agile endpoints jr
   uses (and with what scopes) was not verified endpoint-by-endpoint. Flag for a follow-up spike before
   treating 2LO as a drop-in CI path. [atlassian-svc-oauth]
4. **gh/aws internal config schemas** (`hosts.yml`, credential DB) are implementation details, not public
   schemas — used here only as *pattern* precedent, not as APIs to copy byte-for-byte. [gh-multi]
5. **Version-sensitive facts** (`aws login` in CLI 2.32.0 / Nov 2025; SSO PKCE default in ≥2.22.0; AWS CLI
   v1 EOL 2027-07-15) are current as of 2026-09-01 and should be re-checked if this brief is used later. [aws-login][aws-v1-eol]
6. **Not re-derived here:** jr's current-state internals (levers, keychain layout, ADRs) are taken as given
   from `auth-profile-current-state.md` per instruction; this brief did not re-read source.

---

## Sources

- [gh] `gh auth login` manual — https://cli.github.com/manual/gh_auth_login
- [gh-env] `gh` environment variables — https://cli.github.com/manual/gh_help_environment
- [gh-device] GitHub OAuth device flow — https://docs.github.com/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps
- [gh-switch] `gh auth switch` — https://cli.github.com/manual/gh_auth_switch
- [gh-multi] gh multiple-accounts design — https://github.com/cli/cli/blob/trunk/docs/multiple-accounts.md
- [gh-v010] gh v0.10.0 release (config→hosts.yml migrate-on-first-write) — https://github.com/cli/cli/releases/tag/v0.10.0
- [gh-pat] GitHub managing PATs — https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
- [gcloud-login] `gcloud auth login` — https://cloud.google.com/sdk/gcloud/reference/auth/login
- [gcloud-nobrowser] `gcloud auth login` (beta, `--no-browser`/remote bootstrap) — https://docs.cloud.google.com/sdk/gcloud/reference/beta/auth/login
- [gcloud-activate] `gcloud auth activate-service-account` — https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account
- [gcloud-bestprac] SA security best practices — https://cloud.google.com/iam/docs/best-practices-service-accounts
- [gcloud-configs] gcloud configurations — https://docs.cloud.google.com/sdk/docs/configurations
- [aws-sso] `aws configure sso` — https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html
- [aws-sso-login] `aws sso login` — https://docs.aws.amazon.com/cli/latest/reference/sso/login.html
- [aws-login] `aws login` announcement (CLI 2.32.0, Nov 2025) — https://aws.amazon.com/blogs/security/simplified-developer-access-to-aws-with-aws-login/
- [aws-auth] AWS CLI authentication options — https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-authentication.html
- [aws-envvars] AWS CLI environment variables — https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
- [aws-config] AWS CLI config/credentials files — https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html
- [aws-sso-session] `aws configure sso-session` — https://docs.aws.amazon.com/cli/latest/reference/configure/sso-session.html
- [aws-keys] IAM manage access keys — https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
- [aws-v2] AWS CLI v1→v2 migration — https://docs.aws.amazon.com/cli/latest/userguide/cliv2-migration.html
- [aws-v1-eol] AWS CLI v1 maintenance-mode announcement — https://aws.amazon.com/blogs/developer/cli-v1-maintenance-mode-announcement/
- [stripe-login] Stripe CLI login — https://docs.stripe.com/cli/login
- [stripe-keys] Stripe CLI API keys — https://docs.stripe.com/cli/api_keys
- [k8s-authn] Kubernetes authentication — https://kubernetes.io/docs/reference/access-authn-authz/authentication/
- [k8s-kubeconfig] Kubeconfig API v1 — https://kubernetes.io/docs/reference/config-api/kubeconfig.v1/
- [k8s-organize] Organizing cluster access with kubeconfig — https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
- [k8s-token] `kubectl create token` — https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_token/
- [k8s-warn] Kubernetes API warnings (stderr, --warnings-as-errors) — https://kubernetes.io/blog/2020/09/03/warnings/
- [kubeadm-migrate] `kubeadm config migrate` — https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/
- [gke-authplugin] GKE kubectl auth-plugin migration — https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
- [atlassian-3lo] Atlassian OAuth 2.0 (3LO) apps — https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/
- [atlassian-acli] `acli jira auth login` — https://developer.atlassian.com/cloud/acli/reference/commands/jira-auth-login/
- [atlassian-svc-oauth] Create OAuth 2.0 credential for service accounts (client_credentials/2LO) — https://support.atlassian.com/user-management/docs/create-oauth-2-0-credential-for-service-accounts/
- [atlassian-svc-token] Manage API tokens for service accounts — https://support.atlassian.com/user-management/docs/manage-api-tokens-for-service-accounts/
- [rfc8628] RFC 8628 OAuth 2.0 Device Authorization Grant — https://www.rfc-editor.org/rfc/rfc8628.html
- [rfc8252] RFC 8252 OAuth 2.0 for Native Apps — https://www.rfc-editor.org/rfc/rfc8252.html

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 4 | (1) Auth defaults & mechanisms across gh/gcloud/aws/stripe/kubectl + CI env vars; (2) profile/context/account data models (kubectl contexts, aws profiles+sso-session, gcloud configurations, gh host/account); (3) API-token vs OAuth coexistence/deprecation + config-schema migration conventions; (4) Atlassian 3LO device-flow (RFC 8628) feasibility + RFC 8252 embedded-secret analysis + unattended-CI mechanism. `reasoning_effort` not tuned (default high-depth deep-research preset). |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not used — questions were about product/CLI *behavior and conventions* (best served by web-grounded deep research against official docs), not library API surface. Library-doc lookups were not the bottleneck; every claim is anchored to an official docs/RFC URL. |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Read | 2 | Grounding investigation (`auth-profile-current-state.md`) + one persisted large research result. |
| Training data | 0 areas | No external claim rests on training data alone; all are cited to source URLs. Model knowledge used only to *structure/synthesize* the cited findings and map them onto jr's constraints. |

**Total MCP tool calls:** 4 (all `perplexity_research`, the mandated primary tool for non-trivial synthesis).
**Training data reliance:** low — every external factual claim carries a source URL; version-sensitive
facts are date-stamped 2026-09-01; unverifiable items are explicitly flagged in Open Questions.
