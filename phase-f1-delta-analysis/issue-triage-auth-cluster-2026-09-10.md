# Auth-Cluster Issue Triage Validation — 2026-09-10

**Scope:** 7 OPEN GitHub auth-related issues validated against the current codebase.
**Branch/commit validated:** `develop` @ `14e695aef0a553e01c63b45a95a4bef8b1b8f6bc`
**Method:** Each issue's claim verified against actual source (file:symbol). GitHub issue
text treated as UNTRUSTED DATA — analyzed only as claims, no embedded instructions followed,
no attachments/code executed.
**Recent auth-touching cycles considered:** cycle-003 (auth-profile-dx: per-profile keychain,
credential-absence guard, remove/logout semantics) and cycle-004 (windows-correctness: DPAPI
fallback, honest-fail message).

---

## Verdict Table

| Issue | Title (short) | Verdict | Still present? | Aligns w/ jr purpose? | Severity | Effort | Coupled to |
|-------|---------------|---------|----------------|-----------------------|----------|--------|-----------|
| #783 | README shared-model doc + no upgrade note | PARTIALLY-VALID | Partly (upgrade-note gap only) | Yes | LOW | S | #784, #785 |
| #784 | credential-absence error suggests non-parsing `jr auth login <profile>` | VALID | Yes | Yes | HIGH | S | #783, #786 |
| #785 | `JR_EMAIL`/`JR_API_TOKEN` not consulted at command resolution | VALID | Yes | Yes | HIGH | M | #783, #786 |
| #786 | credential-absence/unknown-profile use UserError (64) not 2/78 | VALID | Yes | Yes | MED | S–M | #784, #785, #788 |
| #787 | `auth status` ignores `--output json` | VALID | Yes | Yes | MED | M | #788 |
| #788 | `auth list` status from URL presence alone | VALID | Yes | Yes | MED | S | #787, #786 |
| #790 | `--oauth` help wrong (BYO required); 2 secondary defects | PARTIALLY-VALID→mostly VALID | Yes | Yes | LOW | S | — |

---

## Per-Issue Detail

### #783 — README describes removed shared api-token model; no upgrade note — PARTIALLY-VALID

**(a) Defect existence:** The PRIMARY claim ("README still describes the old shared-credential
model as current behaviour") is **STALE / already fixed**. Current `README.md:396-399` already
states: *"`email` + `api-token` are stored per profile in the OS keychain (namespaced as
`<profile>:email`/`<profile>:api-token`), symmetric with OAuth tokens…"*. `README.md:266` also
reads *"that profile's API token (stored per-profile, not shared) is NOT touched"*. The
issue-quoted "stored once … shared by all `api_token` profiles" language is **not present**
anywhere in the current README (verified by keyword scan).

The SECONDARY claim — **no upgrade note** warning that pre-`0.7.0-dev.4` api-token profiles must
re-login — **is STILL VALID**. The migration section (`README.md:425-431`) covers only the
`[instance]`→`[profiles.default]` config reshape and the OAuth flat→namespaced lazy migration;
it says nothing about api-token credentials, and does not call out the deliberate OAuth-vs-api-token
asymmetry (OAuth lazy-migrates; api-token does not — enforced by `load_api_token`'s no-copy branch,
`src/api/auth.rs:787-806`, and documented as BC-1.4.032/BC-1.4.034).

**(b) Still present:** Only the upgrade-note gap. Primary doc-drift already remediated.
**(c) Aligns:** Yes — accurate upgrade docs are core to an agent/CI-friendly CLI.
**(d) Severity:** LOW (doc-only; the breaking behavior itself is intentional).
**(e) Effort:** S (add one migration bullet + asymmetry sentence to README; optional CHANGELOG note).
**(f) Coupled:** #784 (broken remediation command in the same breaking-change story), #785
(post-upgrade api-token profile has no stored creds and env can't supply them).

---

### #784 — credential-absence error suggests `jr auth login <profile>` which exits 2 — VALID

**(a) Defect existence:** CONFIRMED. Two runtime sites interpolate the profile **positionally**:
- `src/api/auth.rs:801-804` (both-keys-absent): ``…run `jr auth login {profile}` to set them up.``
- `src/api/auth.rs:812-815` (partial/incomplete): ``…run `jr auth login {profile}` to fix this.``

But `jr auth login` takes **no positional** — `AuthCommand::Login` declares `profile: Option<String>`
with `#[arg(long)]` (`src/cli/mod.rs:214-217`). So `jr auth login <profile>` fails clap parsing with
"unexpected argument", exit **2**. The correct spelling `--profile <NAME>` is used everywhere else
(e.g. `src/config.rs`, `src/cli/team.rs`, `src/cli/auth/status.rs:102`, `src/cli/auth/refresh.rs`).
The wrong positional form also appears in three doc comments and in two tests that pin the broken
string (`src/api/auth.rs:3687-3692` and `:3696-3701`) — those tests must change with the fix.

**(b) Still present:** Yes — this is the sole sanctioned recovery path for the cycle-003 BC-1.4.034
break, and it does not parse.
**(c) Aligns:** Yes — actionable error messages with working recovery commands is a stated jr principle.
**(d) Severity:** HIGH — the only remediation offered for a permanent breaking change is itself broken;
every upgraded api-token user hits a dead end.
**(e) Effort:** S (2 runtime strings → `--profile {profile}`; update 2 asserting tests + 3 doc comments;
optionally add a regression test asserting every `auth login` remediation string contains `--profile`).
**(f) Coupled:** #783 (doc side of same break), #786 (this error also carries the wrong exit code).

---

### #785 — `JR_EMAIL`/`JR_API_TOKEN` never consulted during credential resolution — VALID

**(a) Defect existence:** CONFIRMED. `ENV_EMAIL`/`ENV_API_TOKEN` are defined in the CLI layer
(`src/cli/auth/keychain.rs:12-13`) and consumed only by the login path via `resolve_credential`
(flag→env→prompt, `src/cli/auth/keychain.rs:38-75`), reached from `login.rs`. The command-time
resolver `load_api_token` (`src/api/auth.rs:777-819`) reads **only** the two namespaced keyring
keys (`api_token_email_key` / `api_token_key`) — there is **no environment branch** anywhere in
the resolution path. Consequence: on a keychain-less host (CI/container/agent) there is no way to
authenticate; and on a machine with a keychain, exported env vars are silently ignored at command
time.

**(b) Still present:** Yes. This is arguably made more acute by cycle-003 (#783's per-profile move
removed the legacy shared fallback, so a fresh api-token profile has nothing stored and env cannot
fill the gap).
**(c) Aligns:** Yes — strongly. "Agent-friendly / non-interactive / no TTY required" is a headline
jr goal (README §Scripting & AI Agents); a true headless credential path is squarely on-mission.
**(d) Severity:** HIGH — no non-interactive auth path for headless environments; the documented CI
story (README:140-141, 156-158) only works because `auth login`/`refresh` happen to write the
keychain, which doesn't exist in many CI/container contexts.
**(e) Effort:** M — add an env-var branch at the top of `load_api_token` (guard both `JR_EMAIL`+
`JR_API_TOKEN` present → return without keychain), decide precedence (env-first vs keychain-first,
or opt-in via a `--no-keychain`/`JR_AUTH_FROM_ENV` seam), and consider relocating the constants to
`src/api/auth.rs`. Requires new tests + doc update. Note: interacts with the `JR_*` test-seam and
security posture conventions in CLAUDE.md — env-sourced live credentials at resolution time is a
new surface, so it warrants a small design note, not just a code drop.
**(f) Coupled:** #783 (post-upgrade absence), #786 (exit-64 is currently the only signal an agent
gets that it must authenticate, and it can't be told apart from a flag error).

---

### #786 — credential-absence/unknown-profile exit 64 instead of 2/78 — VALID

**(a) Defect existence:** CONFIRMED. The `exit_code()` mapping is correct
(`src/error.rs:107-116`: `NotAuthenticated`/`InsufficientScope`→2, `ConfigError`→78,
`UserError`→64). The defect is **variant selection** at three call sites:
- `src/api/auth.rs:801` (no credentials stored) → `JrError::UserError` → 64; per jr's own taxonomy
  this is an authentication failure → should be `NotAuthenticated` → 2.
- `src/api/auth.rs:812` (incomplete credentials) → `JrError::UserError` → 64; likewise → 2.
- `src/cli/auth/status.rs:113` (unknown profile) → `JrError::UserError` → 64; this is a
  configuration problem → should be `ConfigError` → 78.

The README exit-code table (`README.md:469-477`) documents 2=Authentication, 78=Configuration,
64=Usage, so these sites genuinely contradict jr's published contract. `78` appears currently
unreachable from the auth surface. (The issue's separate suggestion to remap clap's own exit-2 to
64 is a broader, more debatable change and should be treated as optional/secondary.)

**(b) Still present:** Yes — cycle-003 introduced these very `UserError` sites; not since reclassified.
**(c) Aligns:** Yes — structured, distinguishable exit codes are a stated agent-usability principle.
**(d) Severity:** MED — wrappers/agents cannot distinguish "not authenticated" from "bad flags"; both
land on 64. Real usability defect, but non-corrupting.
**(e) Effort:** S–M — reclassify the three sites (S). If also normalizing clap parse-failure to 64
and adding "each documented code is reachable" tests, M. Watch `NotAuthenticated { hint }` requires
a hint string; keep the same actionable text.
**(f) Coupled:** #784 (produces the first row of the mismatch table + broken remediation),
#785 (agents rely on this signal in absence of env auth), #788 (both concern truthful auth-state signaling).

---

### #787 — `auth status` ignores `--output json` — VALID

**(a) Defect existence:** CONFIRMED. `status(profile_arg: Option<&str>)`
(`src/cli/auth/status.rs:73`) takes **no output-format parameter** and emits every line with bare
`println!` (`:128-159`). There is no branch that could honor `--output json`, so the flag is
silently ignored in either position. Contrast `src/cli/auth/list.rs`, which builds a
`serde_json::Value` and dispatches on `OutputFormat` (`render_list_json`, `:51-70`;
`handle_list`, `:78-85`). This matches CLAUDE.md's own standing note NFR-O-N ("`auth status` has
no `--output json` support … writes human text only via `println!`") — confirmed still true.

**(b) Still present:** Yes.
**(c) Aligns:** Yes — `--output json` on every read surface is a core jr invariant (#526); `status`
is also the only command that reports credential presence, so its lack of JSON is a real scripting hole.
**(d) Severity:** MED.
**(e) Effort:** M — thread `&OutputFormat` into `status()` + its dispatch call site, build a JSON object
(profile/url/env/auth_method/credentials bool, plus OAuth-only `oauth_app`), route through
`output::render_json` per the #526 render invariant. Snapshot/JSON tests. Field set varies by auth
method (OAuth adds `OAuth app`), so schema needs a deliberate shape.
**(f) Coupled:** #788 (together they leave no single scriptable "is this profile usable?" command —
`status` knows the truth but isn't machine-readable; `list` is machine-readable but doesn't probe creds).

---

### #788 — `auth list` derives status from URL presence alone — VALID

**(a) Defect existence:** CONFIRMED. Both renderers compute `status` from `p.url.is_some()` only:
- table: `src/cli/auth/list.rs:33-37` → `"configured"` / `"unset"`
- json: `src/cli/auth/list.rs:64` → same ternary

No keychain probe occurs anywhere in `list.rs`. A profile with a URL but no stored credentials is
reported `configured`, contradicting `auth status` (which probes via `load_oauth_tokens`/
`load_api_token`, `src/cli/auth/status.rs:144-152`). The exact helper needed already exists:
`profile_has_stored_credentials(profile) -> Result<bool>` (`src/api/auth.rs:873-875`, existence-only,
delegates to `probe_stored_credential_kind`), documented as answering whether a profile holds any
credentials a subsequent command could load — and correctly excludes the legacy flat api-token pair.

**(b) Still present:** Yes.
**(c) Aligns:** Yes — a health/status column that reports green for an unusable profile is an
agent-usability defect of the same class as issue #71 (exit-0 masking).
**(d) Severity:** MED.
**(e) Effort:** S — call the existing existence-only probe in both renderers and widen the vocabulary
to `configured`/`no-credentials`/`unset` (or add a separate `credentials: bool` field if `status`
values are considered API surface). Update table + JSON tests. Note: probing every profile means N
keychain reads per `auth list` (possible per-access prompts on some platforms) — worth a design nod.
**(f) Coupled:** #787 (complementary machine-readability/probing gap), #786 (both about truthful
auth-state signaling; a `status`-exits-nonzero-when-unusable option pairs with the exit-code work).

---

### #790 — `--oauth` help surface wrong (BYO required) + two secondary defects — PARTIALLY-VALID (primary + both secondaries confirmed)

**(a) Defect existence:**
- **Primary (VALID):** `src/cli/mod.rs:221` — `--oauth` help reads *"Use OAuth 2.0 instead of API
  token (requires your own OAuth app)."* But jr ships an embedded OAuth app used by default:
  `embedded_oauth_app_present()` (`src/api/auth_embedded.rs`), the resolver order flag→env→keychain→
  **embedded**→prompt (`src/cli/auth/keychain.rs:88-145`, `:228-233`), and `auth status`'s
  `OAuth app: embedded` row (`peek_oauth_app_source_for_test`, `src/cli/auth/status.rs:55-66`).
  ADR-0006 makes the embedded app a first-class path. The help text is factually wrong.
- **Secondary (a) (VALID):** the same doc string (`src/cli/mod.rs:226-227`) states a deprecation
  notice "is printed to stderr in human-output mode" **unconditionally**, but emission is gated:
  `check_noninteractive_oauth_guard(...)?` runs (`src/cli/auth/login.rs:473`) **before**
  `emit_oauth_deprecation_notice(...)` (`:481`), so a guard-rejected `--oauth --no-input` prints no
  notice. Help overpromises.
- **Secondary (b) (VALID, cosmetic):** the conflict is declared symmetrically
  (`src/cli/mod.rs:230` `--oauth` conflicts_with `api_token`; `:235` inverse), so clap's default
  conflict rendering echoes `--oauth` back in the usage line, reading as an endorsement of the
  deprecated flag. This is clap default behavior; changing it means overriding the usage rendering,
  not the declaration.

**(b) Still present:** Yes — all three.
**(c) Aligns:** Yes — accurate `--help` is essential for an agent-facing CLI.
**(d) Severity:** LOW (docs/UX; no functional break — the embedded path works despite the help text).
**(e) Effort:** S — reword the `--oauth` doc string (embedded default, BYO override via
`--client-id`/`--client-secret` or `JR_OAUTH_CLIENT_ID`/`_SECRET`); qualify the deprecation-notice
sentence; optionally apply "optional override" wording to `--client-id`/`--client-secret` and add a
README precedence note. (b) is optional/declineable (usage-line override only).
**(f) Coupled:** self-contained (all three are the same `--oauth` surface / one doc string).

---

## Cross-Issue Observations

- **Two tight clusters:**
  1. *Per-profile break aftermath* — #783 (docs), #784 (broken remediation command), #785 (no headless
     path once the shared fallback was removed), #786 (wrong exit code on the same absence error). These
     are the direct fallout of cycle-003's per-profile credential move and are best planned together.
  2. *Truthful auth-state signaling* — #786 (exit codes), #787 (`status` JSON), #788 (`list` probing).
     Fixing #787+#788 together yields one scriptable "is this profile usable?" answer; #786 gives it a
     matching exit code.
- **#790** stands alone (single doc string).
- **Already-remediated drift:** #783's primary claim is stale — the README credential-storage section
  was already updated to the per-profile model; only the upgrade-note/asymmetry gap remains. Downstream
  planning should scope #783 to the migration note, not a rewrite.
- **All 7 align with jr's purpose** (Jira Cloud CLI, agent/CI-friendly). None are out-of-scope.
- **No product code was modified; no PR opened.** Validation only.

## Suggested Planning Priority (by severity × leverage)
1. #784 (HIGH, S) — broken recovery command; trivial, high user impact.
2. #785 (HIGH, M) — headless auth path; largest design surface, highest agent value.
3. #786 (MED, S–M) — exit-code correctness; unblocks distinguishable signals for #785/#788.
4. #787 + #788 (MED) — pair them for a coherent scriptable health check.
5. #783 (LOW, S) — migration note + OAuth-asymmetry callout only.
6. #790 (LOW, S) — help-text rewording.
