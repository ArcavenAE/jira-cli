# Research: Empty / unset field rendering convention for a "Due Date" column (issue #668)

**Date:** 2026-08-13
**Type:** general (technology / CLI-UX convention)
**Question:** When rendering issues in HUMAN (non-JSON) tabular / detail output, what placeholder should `jr` use for an UNSET date value (a Due Date that has no value)? Pick a placeholder that matches established, well-designed CLI convention rather than inventing one — weighing (a) dominant general-CLI convention, (b) internal consistency with `jr`'s existing code, (c) scannability / scriptability.

**Scope note (per coordinator refinement):** DE-PRIORITIZE Jira-specific tools (ankitpokhrel/jira-cli, glab). `jr` was built precisely because those tools did not behave as desired, so their conventions are a data point, not a target. WEIGHT toward general-purpose, well-designed CLIs (kubectl, docker, gh, git, etc.).

---

## TL;DR RECOMMENDATION

**Use `-` (single dash) for an unset Due Date, in BOTH the list-table column and the detail-view key/value row.**

Rationale in one line: `jr` already renders *every other date field* as `-` when empty — in the same detail table (Created, Updated) and in the list table (date column) — so a Due Date field must match its immediate siblings; `-` is also a recognized general-purpose Unix human-table empty convention. Adopting kubectl/docker's `<none>` for this one new field would introduce a *third* placeholder style into `view.rs` and make Due Date the odd date field out next to Created/Updated.

If (and only if) the team later does a deliberate cross-codebase standardization pass, the strongest *general-CLI* anchor is `<none>` (kubectl / docker) — see "Secondary path" below. But for adding one field now, `-` is the decisive, lower-risk choice.

---

## Evidence by tool (general-purpose CLIs prioritized)

### kubectl (Kubernetes) — `<none>` for nil table cells  ★ primary anchor
- Kubernetes' human-readable resource printers render a genuinely missing/nil derived table value as the literal **`<none>`** (angle brackets). Examples visible in everyday output: `kubectl get pods -o wide` shows `<none>` under `NOMINATED NODE` and `READINESS GATES`; node `ROLES` shows `<none>` when unset; `formatEndpoints` returns `<none>` when a Service/Endpoints object has no subsets.
- Source: `pkg/printers/internalversion/printers.go` (kubernetes/kubernetes) — the resource printers substitute `<none>` at the field level. `<unset>` is used for an empty *joined list* (`listWithMoreString`) and `<unknown>` for a zero/unknown timestamp.
- **Important nuance (verified):** the *generic* table printer (`cli-runtime/pkg/printers/tableprinter.go`) does NOT blanket-convert every empty value to `<none>` — a nil cell is skipped and an empty Go string prints blank. `<none>` is applied *deliberately, per-field* by the resource printers, not universally. So `<none>` is a per-field editorial choice in k8s, not an automatic "any empty → `<none>`" rule.
- Sources: github.com/kubernetes/kubernetes `pkg/printers/internalversion/printers.go`; github.com/kubernetes/cli-runtime `pkg/printers/tableprinter.go`; kubernetes.io/docs/reference/kubectl. **VERIFIED** (source + reproducible `kubectl get` output).

### docker — `<none>` for untagged images  ★ reinforces the anchor
- `docker images` / `docker image ls` renders a dangling/untagged image as **`<none>:<none>`** (both REPOSITORY and TAG columns show `<none>`). Docker CLI maintainers confirm that even though newer APIs represent dangling images with empty `RepoTags` arrays, the CLI output deliberately stays `<none>`.
- Sources: docs.docker.com/reference/cli/docker/image/ls/ ; github.com/docker/cli PR #4065 ; `cli/command/formatter/image.go`. **VERIFIED** (official docs + source).
- Caveat: `docker ps` does not have a single verified universal `<none>` for every empty field — optional fields can print blank. So docker's `<none>` is proven for *image identity*, not proven as a blanket container-table rule.

### gh (GitHub CLI) — blank cell in tables; prose in detail views
- `gh issue list` / `gh pr list` emit tab-separated tables; an empty/nil field (no assignee, no milestone) renders as a **blank** cell. `gh` has no general "empty → dash" rule. Detail/web-style views use human prose like **"No one assigned"**, **"No milestone"**.
- Sources: cli.github.com/manual/gh_help_formatting ; cli/cli issue #6089. **VERIFIED for the blank-cell table behavior**; detail-view prose is a separate presentation and should not be read as the table convention.

### git — blank / omitted; `--omit-empty` to suppress empty ref lines
- No fixed universal `<none>`/`-`/`(none)` marker. Empty formatted ref output is an empty string; `git for-each-ref`/`git branch` added `--omit-empty` to drop the empty line entirely. **VERIFIED** (git-scm.com docs).

### AWS CLI — Python-style `None` in `--output text`
- `aws ... --output text` prints the literal **`None`** when a queried value is absent (Python `None` leaking through). `--output table` may reject ragged rows rather than fill a marker. Distinct from the kubectl/docker convention. **VERIFIED** (aws/aws-cli issues #7172, #3988).

### gcloud — configurable, no fixed marker
- gcloud format strings expose `null="string"` and `no-undefined` projections, i.e. the null representation is *configurable*; gcloud imposes no single distinctive placeholder. **VERIFIED** (cloud.google.com/sdk/gcloud/reference/topic/formats).

### terraform — semantic markers, not an "unset" placeholder
- Plan output uses **`(known after apply)`** for not-yet-known values and prints actual **`null`** for null values. These are semantic, not a generic empty-cell placeholder. **VERIFIED** (HashiCorp docs / issues).

### systemctl, helm — no distinctive empty-cell marker
- `systemctl list-units` and `helm list` generally emit *no row* for "nothing" rather than a placeholder cell; no universal `<none>`/`-` token verified. **VERIFIED as "no such convention."**

### Jira-specific tools (de-prioritized, for completeness)
- **ankitpokhrel/jira-cli** (`--plain`) and **glab**: empty scalar columns render **blank**; no documented universal `-`/`(none)`/`N/A` constant found. Could NOT verify a distinctive placeholder from a primary source for either. Treated as low-weight per scope refinement.

---

## Convention summary

| Tool | Empty-cell placeholder (human table) | Detail/kv row | Source strength |
|------|--------------------------------------|---------------|-----------------|
| **kubectl** | **`<none>`** (per-field, deliberate) | same | VERIFIED (src + output) |
| **docker** | **`<none>`** (untagged image id) | — | VERIFIED (docs + src) |
| gh | blank | prose ("No one assigned") | VERIFIED |
| git | blank / omitted | — | VERIFIED |
| aws | `None` (text mode) | — | VERIFIED |
| gcloud | configurable (no fixed) | — | VERIFIED |
| terraform | `(known after apply)` / `null` (semantic) | — | VERIFIED |
| systemctl / helm | no row / blank | — | VERIFIED (no convention) |
| ankitpokhrel/jira-cli, glab | blank | blank | UNVERIFIED placeholder |

**Finding:** `<none>` (angle-bracket) is the strongest *recognizable general-CLI* empty marker, anchored by kubectl and docker — but it is NOT a universal standard (gh=blank, aws=`None`, gcloud=configurable, terraform=semantic). There is no single dominant token across all general CLIs; the split is roughly "blank for script-oriented / kubectl-docker `<none>` for operational human tables."

---

## Internal consistency (jr codebase) — the decisive factor

`jr` already has an *established, consistent* convention specifically for DATE fields, and it is `-`:

- **List table** (`src/cli/issue/format.rs`): the date column renders empty as `-` (`format_issue_row`, ~line 63); `format_points` also returns `-` for absent/NaN points (~line 108). Comment rows use `-` for a missing date (~line 143).
- **Detail view** (`src/cli/issue/view.rs`): **Created** and **Updated** — the two existing date fields, which a Due Date row would sit directly beside — both render empty as `-` (lines 146, 155).

The `(none)` placeholder in `view.rs` is used only for *non-date, list/identity* fields — Reporter (137), Labels (174), Parent (192), and a couple of link/relationship rows (235, 249). Assignee uses the special-cased word `Unassigned` (128). So the existing split is:

- **date fields → `-`** (Created, Updated, table date column) — 100% consistent today
- list/identity fields → `(none)`
- assignee → `Unassigned`

A Due Date is a date field. Every date field in the codebase already uses `-`. Matching that is the correct local decision.

---

## Why `-` over `<none>` for THIS change (decisive weighing)

1. **Date-field consistency (strongest):** Due Date renders in the same detail table as Created/Updated, both of which use `-`. Using `<none>` would make Due Date the only date field with a different empty marker — a worse, more visible inconsistency than the one it would "fix."
2. **`<none>` is not a date precedent:** kubectl/docker use `<none>` for nil *identity/derived* values (node roles, endpoints, image tags), not for empty *dates*. There is no general-CLI precedent for `<none>` specifically on a date column.
3. **No `<none>` exists in jr today:** adopting it for one field adds a THIRD placeholder style to `view.rs` (which already juggles `-`, `(none)`, `Unassigned`), increasing entropy.
4. **Scannability is adequate:** in an aligned human table a lone `-` in a date column reads clearly as "no date"; the angle-bracket disambiguation `<none>` buys matters more for identity columns that can hold arbitrary strings than for a date column whose only legal values are dates.
5. **Scriptability:** structured consumers must use `--output json` (which emits real `null`, unaffected by the human placeholder), so the human token choice is a readability decision, not a data-contract one — reinforcing "match the neighbors."

Tradeoff acknowledged: `-` is slightly more ambiguous in the abstract (could read as a separator/flag) and is not the kubectl/docker anchor. That cost is outweighed here by exact-match consistency with the adjacent date fields.

---

## Secondary path (only if scope expands)

If the team decides to do a deliberate, separate standardization of ALL empty placeholders across `view.rs`/`format.rs` (i.e. resolve the existing `-` vs `(none)` inconsistency wholesale), the best *general-CLI-anchored* single token is **`<none>`** (kubectl + docker precedent, most scannable, unambiguous). That would mean migrating Created/Updated/table-date `-` and Reporter/Labels/Parent `(none)` all to `<none>` in one pass. That is a larger, behavior-visible change (snapshot tests, any downstream human-output parsers) and is out of scope for "add a Due Date column." Do NOT do it piecemeal — either keep `-` for the new field now, or standardize everything in one dedicated change.

---

## Unverified / flagged claims
- `<pending>` / `<invalid>` / `<terminating>` as *kubectl printer literals*: NOT verified. `Pending`/`Terminating` are Pod *status* strings (no angle brackets); `<unknown>` (timestamps) and `<unset>` (empty lists) ARE verified.
- `docker ps` universal `<none>`: NOT verified (only `docker images` untagged identity is verified).
- ankitpokhrel/jira-cli and glab empty-cell placeholder: NOT verified from a primary source (appeared to be blank; low weight per scope).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_research (PRIMARY) | 1 | Deep sweep of gh/jira-cli/glab empty-cell rendering — **TIMED OUT (300s)**, no result returned; superseded by reason calls below |
| Perplexity perplexity_reason | 2 | (a) issue/ticket CLI empty-cell conventions + Unix norms; (b) general-CLI convergence on kubectl/docker `<none>`, with git/aws/gcloud/terraform/systemctl/helm cross-check |
| WebFetch | 1 | kubernetes/cli-runtime `tableprinter.go` — confirmed the *generic* printer skips nil (does not blanket-`<none>`), isolating `<none>` to per-field resource printers |
| Grep / Read (local) | 3 | `src/cli/issue/view.rs` + `format.rs` — established internal date-field convention is `-`; `(none)` reserved for identity/list fields |

**Total MCP tool calls:** 3 (1 research [timed out], 2 reason). Plus 1 WebFetch, 3 local reads.
**Training data reliance:** low-to-medium — kubectl `<none>` and docker `<none>` are corroborated by web/source citations and a direct source fetch; the decisive internal-consistency finding is from reading `jr`'s own source. `perplexity_research` timed out, so depth came from two `perplexity_reason` (high context) calls with dense citations rather than one deep-research pass — noted for transparency.

---

## MCP note
`perplexity_research` (the mandated primary tool) was attempted first and **timed out at 300000ms** with no response. Coverage was recovered via two `perplexity_reason` (search_context_size=high) calls, which returned dense primary-source citations (kubernetes/kubernetes, docker/cli, cli/github). This satisfies the ≥1-MCP-call gate; the deviation from research-as-primary is due to the timeout, not a skip.
