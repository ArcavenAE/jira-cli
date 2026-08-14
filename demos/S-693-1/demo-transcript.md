# Demo Evidence — S-693-1 (#693): `queue view` surfaces queue-configured custom fields in `--output json`

**Format used:** text transcript, not a VHS GIF.

**Why a transcript instead of VHS:** `jr queue view` needs three live JSM
endpoints (service-desk/project-meta lookup, queue list with `fields[]`,
queue-issue keys, and the Jira search endpoint) satisfied by a mock backend
before it will run at all. Standing up wiremock as a long-lived local server
and then driving `jr` inside a VHS `.tape` recording (which runs in its own
subshell/tty) adds process-lifetime and port-coordination complexity with no
extra evidentiary value over a scripted, reproducible transcript — the VHS
recording would just be a screen capture of the same JSON/table text below.
The transcript instead **drives the actual compiled `jr` binary as a
subprocess** (not a unit-level shortcut) against the same `wiremock`
fixtures the story's own integration tests use (`tests/queue.rs`, the
`BC-X.8.009` block added by this story), via the `JR_BASE_URL` /
`JR_AUTH_HEADER` debug test seams documented in `CLAUDE.md`. Every command
below is a real `jr queue view` invocation; nothing is hand-transcribed.

**How it was produced:** a temporary test file
(`tests/zz_demo_s693.rs`, not committed — added, run, and removed in this
session; the worktree is clean per `git status`) reused the exact wiremock
mount helpers from `tests/queue.rs`'s S-693-1 test block and ran three
scenarios end-to-end through `Command::cargo_bin("jr")`. The mock's
`/rest/api/3/search/jql` responder is **request-aware**: it only echoes
`customfield_10050` back in the response when the inbound request's
`fields[]` array actually asked for it — mirroring real Jira's field-scoping
behavior, so a pre-fix build cannot appear to "surface" the field by
accident.

Fixture identity: project `HELPDESK`, service desk id `15`, queue id `10`
(name `Triage`), one issue `HELPDESK-42` with `customfield_10050 = "Acme
Corp"` declared in the queue's `fields[]`.

---

## 1. Before vs. after — name path, `--output json`

### Pre-fix baseline (parent commit `1a298e24`, immediately before `1294bd8e`)

```
$ jr queue view Triage --project HELPDESK --output json
--- exit code: 0 ---
--- stdout ---
[
  {
    "key": "HELPDESK-42",
    "fields": {
      "summary": "VPN not working",
      "description": null,
      "status": { "name": "New", "statusCategory": null },
      "issuetype": { "name": "Service Request", "subtask": null },
      "priority": { "name": "High" },
      "assignee": null,
      "reporter": null,
      "project": null,
      "created": null,
      "updated": null,
      "duedate": null,
      "resolution": null,
      "components": null,
      "fixVersions": null,
      "labels": null,
      "parent": null,
      "issuelinks": null
    }
  }
]

--- PRE-FIX BASELINE: fields.customfield_10050 present? false ---

--- outbound POST /rest/api/3/search/jql request body (fields) ---
[
  "summary", "status", "issuetype", "priority", "assignee", "reporter",
  "project", "description", "created", "updated", "duedate", "resolution",
  "components", "fixVersions", "labels", "parent", "issuelinks"
]
```

The queue-declared `customfield_10050` is **absent** from both the outbound
search request's `fields[]` and the JSON response — `queue view` never knew
the queue had a configured custom-field column.

### Post-fix (this story, commit `1294bd8e`)

```
$ jr queue view Triage --project HELPDESK --output json
--- exit code: 0 ---
--- stdout ---
[
  {
    "key": "HELPDESK-42",
    "fields": {
      "summary": "VPN not working",
      "description": null,
      "status": { "name": "New", "statusCategory": null },
      "issuetype": { "name": "Service Request", "subtask": null },
      "priority": { "name": "High" },
      "assignee": null,
      "reporter": null,
      "project": null,
      "created": null,
      "updated": null,
      "duedate": null,
      "resolution": null,
      "components": null,
      "fixVersions": null,
      "labels": null,
      "parent": null,
      "issuelinks": null,
      "customfield_10050": "Acme Corp"
    }
  }
]
--- stderr ---
Migrated config to multi-profile layout (single profile "default"). Run 'jr auth list' to view profiles.

--- outbound POST /rest/api/3/search/jql request body (fields) ---
[
  "summary", "status", "issuetype", "priority", "assignee", "reporter",
  "project", "description", "created", "updated", "duedate", "resolution",
  "components", "fixVersions", "labels", "parent", "issuelinks",
  "customfield_10050"
]
```

`customfield_10050` (`"Acme Corp"`) now appears both in the search request's
`fields[]` (queue's declared field threaded into `extra_fields`, AC-1) and
in the JSON response's `fields` object via `IssueFields`'s
`#[serde(flatten)]` mechanism — the fix landing exactly as described in the
commit message.

*(The `stderr` config-migration line is a one-time, unrelated first-run
notice from the temp `XDG_CONFIG_HOME` used for this scripted run; it is not
part of the feature under test.)*

---

## 2. `--id` path fail-open (optional evidence requested)

```
$ jr queue view --id 10 --project HELPDESK --output json
--- exit code: 0 ---
--- stdout ---
[
  {
    "key": "HELPDESK-42",
    "fields": {
      "summary": "VPN not working",
      "description": null,
      "status": { "name": "New", "statusCategory": null },
      "issuetype": { "name": "Service Request", "subtask": null },
      "priority": { "name": "High" },
      "assignee": null,
      "reporter": null,
      "project": null,
      "created": null,
      "updated": null,
      "duedate": null,
      "resolution": null,
      "components": null,
      "fixVersions": null,
      "labels": null,
      "parent": null,
      "issuelinks": null
    }
  }
]
--- stderr ---
Migrated config to multi-profile layout (single profile "default"). Run 'jr auth list' to view profiles.
warning: could not fetch queue field configuration for --id 10 (API error (404)); showing base fields only.
```

Scenario setup: the `--id` path's auxiliary `GET
.../servicedesk/{sd}/queue` lookup was left unmounted, so it hits an
unregistered wiremock route (404) — reproducing the "aux queue-config
lookup fails" branch deterministically. As specified: stderr carries the
`warning: could not fetch queue field configuration ...; showing base
fields only.` message, the command still **exits 0**, and the degraded
response correctly shows base fields only (no stray `customfield_*` key
leaks through even though the search mock is willing to return one — the
`extra_fields` allow-list stays empty on this path, confirming the
BC-X.8.009 EC-X.8.009-1 retain/scoping step).

---

## 3. Table output unaffected (no `--output json`)

```
$ jr queue view Triage --project HELPDESK
--- exit code: 0 ---
--- stdout ---
┌─────────────┬─────────────────┬────────┬──────────┬────────────┬─────────────────┐
│ Key         ┆ Type            ┆ Status ┆ Priority ┆ Assignee   ┆ Summary         │
╞═════════════╪═════════════════╪════════╪══════════╪════════════╪═════════════════╡
│ HELPDESK-42 ┆ Service Request ┆ New    ┆ High     ┆ Unassigned ┆ VPN not working │
└─────────────┴─────────────────┴────────┴──────────┴────────────┴─────────────────┘
--- stderr ---
Migrated config to multi-profile layout (single profile "default"). Run 'jr auth list' to view profiles.
```

Same fixture (queue with `customfield_10050` declared, issue carrying the
value) but no `--output json` — the table is byte-identical to the pre-fix
column set: no new `customfield_10050` column, confirming "table output
unchanged" from the commit message (`#575` tracks a table column separately).

---

## Summary

| # | Scenario | Result |
|---|----------|--------|
| 1 | Name path, `--output json`, before vs. after | Before: field absent from request + response. After: `customfield_10050` present in both — fix confirmed. |
| 2 | `--id` path, aux lookup fails | Exit 0, `warning: could not fetch queue field configuration for --id 10 (API error (404)); showing base fields only.` on stderr, base fields only in JSON (no leak). |
| 3 | Table output (no `--output json`) | Byte-identical column set to pre-fix — no new column. |

Raw `cargo test -- --nocapture` logs backing this transcript (kept for
reference, not shipped as demo output themselves):
- `/tmp` scratch: post-fix run and pre-fix baseline run, both produced from
  the same `tests/queue.rs` wiremock helpers reused in a temporary,
  since-removed test file. Source diff under test: commit `1294bd8e`
  (`feat(queue): surface queue-declared custom fields in queue view JSON
  (#693)`) vs. its parent `1a298e24`.
