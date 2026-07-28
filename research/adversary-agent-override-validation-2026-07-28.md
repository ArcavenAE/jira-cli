# Agent Override Claim Validation (C1–C6)

**Date:** 2026-07-28
**Purpose:** Gate a config change concerning a project-level `adversary` agent vs the plugin agent `vsdd-factory:adversary`.
**Method:** Official Claude Code docs (`code.claude.com/docs`, canonical host after the `docs.claude.com` 301), plus labelled GitHub issues where docs are silent. Direct observation of this session's agent registry where relevant.

## Primary sources

| Ref | Source |
| :-- | :----- |
| S1 | https://code.claude.com/docs/en/sub-agents ("Create custom subagents") |
| S2 | https://code.claude.com/docs/en/plugins-reference ("Plugins reference") |
| S3 | https://code.claude.com/docs/en/permissions ("Configure permissions") |
| S4 | https://code.claude.com/docs/en/errors ("Error reference") |
| G1 | https://github.com/anthropics/claude-code/issues/47936 — `[BUG] (Async) Subagents stopping early` (CLOSED; labels `bug, has repro, area:agent-sdk, stale`; 2026-04-14) |
| G2 | https://github.com/anthropics/claude-code/issues/54323 — `[BUG] Subagent Responses Not Returned to User` (CLOSED; labels `bug, area:agents, stale`; 2026-04-28) |
| G3 | https://github.com/anthropics/claude-code/issues/41143 — `[BUG] maxTurns frontmatter not enforced on sub-agents` (CLOSED; labels `bug, has repro, area:agents`; 2026-03-30) |
| G4 | https://github.com/anthropics/claude-code/issues/25569 — `CLAUDE_CODE_MAX_OUTPUT_TOKENS not applied to subagent (Task tool) API calls` (CLOSED as `duplicate`; 2026-02-13) |
| G5 | https://github.com/anthropics/claude-code/issues/9354 — `${CLAUDE_PLUGIN_ROOT}` empty/undefined in command markdown (2025-10-11) |

---

## C1 — Namespaced plugin agents vs bare-name project agents; separate addressability

**Verdict: SPLIT — first half CONFIRMED, second half REFUTED for bare-name resolution / CONFIRMED for scoped-name resolution.**

Confirmed (S2, "Required fields"), verbatim:

> This name is used for namespacing components. For example, in the UI, the agent `agent-creator` for the plugin with name `plugin-dev` will appear as `plugin-dev:agent-creator`.

And S1 ("Choose the subagent scope"):

> Plugin `agents/` directories are also scanned recursively. Unlike project and user scopes, a subfolder inside a plugin's `agents/` directory becomes part of the scoped identifier: a file at `agents/review/security.md` in plugin `my-plugin` registers as `my-plugin:review:security`.

> **Plugin subagents** come from plugins you've installed. They load automatically alongside your custom subagents and appear in the @-mention typeahead under their scoped name.

Project/user agents are identified by the bare frontmatter `name` (S1): "The subdirectory path doesn't affect how a subagent is identified or invoked, because identity comes only from the `name` frontmatter field."

Empirically corroborated: in this session the agent registry lists plugin agents under scoped names (`vsdd-factory:adversary`, `plugin-dev:agent-creator`, `pr-review-toolkit:code-reviewer`) while built-ins are bare (`Explore`, `Plan`, `general-purpose`).

**But the "does NOT shadow / both separately addressable" claim does not survive.** S1's scope table is explicit that same-name collisions are resolved by precedence, and that plugins are the *lowest* priority:

> Store subagent files in different locations depending on scope. **When multiple subagents share the same name, Claude Code uses the one from the higher-priority location.**

| Location | Scope | Priority |
| :-- | :-- | :-- |
| Managed settings | Organization-wide | 1 (highest) |
| `--agents` CLI flag | Current session | 2 |
| `.claude/agents/` | Current project | 3 |
| `~/.claude/agents/` | All your projects | 4 |
| Plugin's `agents/` directory | Where plugin is enabled | 5 (lowest) |

That bare-name resolution genuinely reaches plugin agents is confirmed by S1's `--agent` documentation:

> For a plugin-provided subagent, you can pass only the agent name and Claude Code finds it: `claude --agent security-reviewer`
> If multiple plugins provide agents with the same name, pass the scoped name to disambiguate: `claude --agent my-plugin:security-reviewer`

So a bare `adversary` reference is a *contested* identifier: a project-level `.claude/agents/adversary.md` (priority 3) outranks the plugin's (priority 5). The scoped form `vsdd-factory:adversary` remains documented as reachable (`--agent my-plugin:x`, `@agent-my-plugin:x`), so the plugin agent is not *erased* — but it is displaced from the bare name.

**Silence to note:** every documented disambiguation example in S1 is *plugin-vs-plugin*. The docs never work a *project-vs-plugin* same-name example end to end, so whether the scoped form still resolves cleanly when a higher-priority project agent has taken the bare name is not directly stated. Treat "both separately addressable" as an inference, not documented behavior.

---

## C2 — Documented precedence and genuine override of a plugin agent

**Verdict: CONFIRMED (precedence is documented). Override semantics: PARTIALLY documented — "override the bare name" yes, "make the plugin agent inaccessible" no.**

Precedence: the priority table in C1 above (S1). Additionally, S1:

> **Managed subagents** … Managed definitions take precedence over project and user subagents with the same name.

Same-name collisions *within one scope* are explicitly undefined behavior (S1):

> Keep `name` values unique across the whole tree: if two files under the same `.claude/agents/` directory, including its subfolders, declare the same name, Claude Code loads only one of them, **chosen by filesystem read order rather than a documented precedence.** Across nested project directories, the definition closest to the working directory wins.

**Documented override paths:**

1. **Same-name at a higher-priority scope.** The direct analogue is stated for built-ins (S1): "A user or project subagent named `Explore` overrides the built-in and keeps its own `model` field, so define one with `model: haiku` to keep exploration on a lower-cost model." The scope table extends the same mechanism to plugins (priority 5, lowest).
2. **Copy the plugin agent file into `.claude/agents/`.** S1 recommends exactly this, in the context of the plugin field restrictions:
   > For security reasons, plugin subagents don't support the `hooks`, `mcpServers`, or `permissionMode` frontmatter fields. These fields are ignored when loading agents from a plugin. **If you need them, copy the agent file into `.claude/agents/` or `~/.claude/agents/`.**

   This is the closest the docs come to endorsing a deliberate plugin-agent override.
3. **Disable the plugin** (`/plugin`, `claude plugin disable`) — removes the plugin agent entirely rather than overriding it.

**Not documented:** any mechanism that makes a plugin agent *unreachable by its scoped name* while the plugin stays enabled. The docs are silent on this.

---

## C3 — `${CLAUDE_PLUGIN_ROOT}` in a project-level agent

**Verdict: CONFIRMED, with one undocumented detail (the failure shape).**

S2 scopes the substitution table explicitly to plugin components:

> `${CLAUDE_PLUGIN_ROOT}` — Resolves to: Absolute path to **the plugin's** installation directory.

> All three are exported as environment variables to hook processes and to MCP and LSP server subprocesses. **Which fields substitute them inline depends on the plugin component:**
>
> | Plugin component | Fields where placeholders resolve |
> | :-- | :-- |
> | **Skill and agent content** | Anywhere the placeholder appears |
> | Hook and monitor commands | Anywhere the placeholder appears |
> | MCP `stdio` servers | `command`, `args`, `env` |
> | … | … |

Inline substitution in agent *content* is therefore a documented **plugin-component** behavior. The variable's definition is inherently plugin-relative — there is no plugin whose root could be resolved for a file in `.claude/agents/`.

Corroborating: S1 (the subagents page) never mentions `${CLAUDE_PLUGIN_ROOT}` at all — zero occurrences. `${CLAUDE_PROJECT_DIR}` is the project-scoped analogue (S2).

**Docs are silent** on the exact failure mode in a non-plugin file: whether the placeholder is left as literal text or substituted with an empty string. G5 reports the empty/undefined shape in an unsupported context ("The CLAUDE_PLUGIN_ROOT environment variable is not set (empty/undefined)… `${CLAUDE_PLUGIN_ROOT}` expands to nothing"). Either way it will not expand to a plugin directory — do not rely on it in a project-level agent.

---

## C4 — Agent frontmatter schema

**Verdict: CONFIRMED, with corrections to the claim's premises.**

S1 ("Supported frontmatter fields"): "Only `name` and `description` are required." Full field list:

| Field | Required | Notes (condensed from S1) |
| :-- | :-- | :-- |
| `name` | **Yes** | Lowercase letters and hyphens. Hooks receive it as `agent_type`. Filename need not match |
| `description` | **Yes** | When Claude should delegate to this subagent |
| `tools` | No | Tools the subagent can use. **Inherits every tool available to subagents if omitted** |
| `disallowedTools` | No | Denylist; removed from the inherited or specified list |
| `model` | No | `sonnet`, `opus`, `haiku`, `fable`, a full model ID (e.g. `claude-opus-5`), or `inherit`. **Defaults to `inherit`** |
| `permissionMode` | No | `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan`, `manual` (alias, ≥2.1.200). **Ignored for plugin subagents** |
| `maxTurns` | No | Maximum agentic turns before the subagent stops |
| `skills` | No | Skills preloaded into context at startup (full content injected) |
| `mcpServers` | No | **Ignored for plugin subagents** |
| `hooks` | No | Subagent-scoped lifecycle hooks. **Ignored for plugin subagents** |
| `memory` | No | `user`, `project`, or `local` |
| `background` | No | `true` to always run as a background task |
| `effort` | No | `low`, `medium`, `high`, `xhigh`, `max` |
| `isolation` | No | `worktree` (only valid value per S2) |
| `color` | No | `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` |
| `initialPrompt` | No | Auto-submitted first user turn when run as main session agent (`--agent`) |

Sub-answers:

- **`color` is valid** — enumerated above.
- **`tools:` format.** Comma-separated is the documented markdown form (S1 example: `tools: Read, Grep, Glob, Bash`). YAML list form is used for the `--agents` JSON equivalent (`"tools": ["Read","Grep","Glob","Bash"]`). Scoped form exists for `Agent`: `tools: Agent(worker, researcher), Read, Bash`.
- **`model:` values.** `opus`, `sonnet`, `haiku`, `fable`, full model IDs, and `inherit` are all valid. `inherit` is the default.
- **`tools:` omitted** → "Inherits every tool available to subagents." Note two documented narrowing filters apply regardless: a global filter removes a short list of tools from every subagent, and a second filter applies to **background** subagents (the default as of v2.1.198), which keep every MCP tool but only these built-ins: `Read`, `Grep`, `Glob`, `Bash`, `PowerShell`, `Edit`, `Write`, `NotebookEdit`, `WebFetch`, `WebSearch`, `TodoWrite`, `Skill`, `ToolSearch`, `EnterWorktree`, `ExitWorktree`, `Monitor`, `TaskStop`, `SendMessage`, `Artifact`. Consequence stated verbatim in S1: "the same definition can resolve to different tools in the foreground and the background."
- **Plugin agents accept a narrower set** (S2): `name`, `description`, `model`, `effort`, `maxTurns`, `tools`, `disallowedTools`, `skills`, `memory`, `background`, `isolation`. `hooks` / `mcpServers` / `permissionMode` are silently ignored.
- **Empty resolution is fatal:** if no `tools` entry resolves to a tool, the subagent "usually fails to launch" with the `would be spawned with zero tools — refusing` error (S1, S4).

---

## C5 — Subagent does tool work, then no final message reaches the parent

**Verdict: CONFIRMED as a real, reproduced failure mode — but documented in GitHub issues, not in official docs. Root cause is NOT authoritatively established. SendMessage-to-resume is a documented capability but is NOT documented as a recovery path for this specific failure.**

**The failure mode, verbatim from G1:**

> Subagents spawned via the Task tool with `run_in_background: true` can stop executing before completing their work, and the Claude Agent SDK reports them as `<status>completed</status>` to the parent agent. The parent has no reliable way to distinguish a subagent that finished successfully from one that was terminated prematurely.
>
> - Make anywhere from 5-40 tool calls over 2-10 minutes
> - Were still actively making tool calls when execution stopped (`stop_reason: None` on final messages)
> - Never reached the final step of their instructions (writing output to a file)
> - Were reported to the parent as `<status>completed</status>`
>
> This is a recurring pattern, seems to happen in about **14-30% of agent runs.** I do not think this is a prompting issue because it always happens after some tool results — the subagent uses a tool, gets the result, and just stops without producing any output.

The diagnostic signature G1 gives is exactly the one described in the claim: the notification carries `<status>completed</status>` but **no `<result>` block**. A healthy run carries both. G1: "The only observable difference is the presence/absence of `<result>`. The `<status>` is identical in both cases." The subagent's final assistant messages carried `stop_reason: None` rather than `end_turn` — i.e. the model did not choose to stop; something external ended the session.

**Related reports:**

- **G2** — subagent responses (Explore, Plan, general-purpose) complete but output is silently dropped, surfacing as "Claude Code finished without returning a reply."
- **G3** — `maxTurns` reported as not enforced on subagents (72 turns observed with `maxTurns: 10`). This *weakens* max-turns as an explanation for the missing-report class.
- **G4** — `CLAUDE_CODE_MAX_OUTPUT_TOKENS` reportedly not applied to subagent calls (hardcoded 32K); closed as duplicate. Relevant to output-exhaustion as a candidate cause but not established.

All four are **CLOSED**; G1 and G2 are labelled `stale`, so closure does not evidence a fix.

**What official docs do cover** — a *different*, cleanly-signalled case (S4):

> `Agent terminated early due to an API error: <error detail>` — A subagent's API request failed terminally … so the subagent stopped before finishing its task. When a rate limit, overload, or server error interrupts a foreground subagent that already produced text output, Claude receives that partial output marked as incomplete instead of this error. A subagent whose only output was tool calls gets this error too.
>
> **What to do:** … Once the underlying error clears, ask Claude to retry the task or **resume the subagent**.

This is the one place the docs tie "stopped before finishing" to a resume-based recovery — and it is scoped to terminal API errors, which *do* raise an explicit error. It does not cover the silent `completed`-without-`<result>` case.

**On SendMessage as recovery.** Resuming via `SendMessage` is fully documented (S1) as a general capability:

> A completed subagent that receives a `SendMessage` auto-resumes in the background without a new `Agent` invocation. The same applies to a subagent that Claude stopped with the `TaskStop` tool.
> Resumed subagents retain their full conversation history, including all previous tool calls, results, and reasoning. The subagent picks up exactly where it stopped rather than starting fresh.

Two documented caveats: (a) built-in `Explore` and `Plan` are one-shot, return no agent ID, and **cannot** be resumed; (b) as of v2.1.191 a subagent stopped by the *user* (`x` in `/tasks`, SDK `stop_task`) does not auto-resume and `SendMessage` returns a refusal.

So: technically available and semantically well-suited, but **framing it as the recognised recovery path for this failure is an inference, not documentation.**

**Documented mitigation, from the issue thread rather than the docs:** have the parent verify the subagent's expected output artifact (e.g. a file) rather than trusting `completed` status. Note the tension with the "no report files" convention some workflows impose — if the parent's only channel is the final message, there is no artifact to verify.

---

## C6 — Does granting `Bash` alongside `Read`/`Grep`/`Glob` erode the tool-restriction guarantee?

**Verdict: CONFIRMED. Granting `Bash` turns a structural guarantee into a conventional one unless it is backed by `Read`/`Edit` deny rules *and*, for full coverage, OS-level sandboxing.**

Three independent statements in S3 establish this.

**1. Common read commands are auto-allowed in every mode:**

> Claude Code recognizes a built-in set of Bash commands as read-only and runs them without a permission prompt in every mode. These include `ls`, `cat`, `echo`, `pwd`, `head`, `tail`, `grep`, `find`, `wc`, `which`, `diff`, `stat`, `du`, `cd`, and read-only forms of `git`. **The set is not configurable;** to require a prompt for one of these commands, add an `ask` or `deny` rule for it.

So `cat` and `grep` need no approval — a Bash-equipped agent reads files freely by default.

**2. Path-based deny rules cover only *recognized* file commands:**

> Read and Edit deny rules apply to Claude's built-in file tools and to file commands Claude Code recognizes in Bash, such as `cat`, `head`, `tail`, and `sed`. **They don't apply to arbitrary subprocesses that read or write files indirectly, like a Python or Node script that opens files itself.** For OS-level enforcement that blocks all processes from accessing a path, enable the sandbox.

This is the decisive sentence. Even with deny rules in place, `python -c "print(open('/x').read())"` is outside their reach. Application of `Read` rules to non-Read built-ins is itself described only as best-effort:

> Claude makes a **best-effort attempt** to apply `Read` rules to all built-in tools that read files like Grep and Glob…

**3. The docs acknowledge Bash argument rules are structurally bypassable:**

> A rule like `Bash(command:rm *)` **would be bypassable by a compound command,** so Claude Code ignores it and emits a startup warning.

**Where the real boundary is** (S3, "How permissions interact with sandboxing"):

> **Sandboxing** provides OS-level enforcement that restricts the Bash tool's filesystem and network access. It applies only to Bash commands and their child processes.
> Sandbox restrictions prevent Bash commands from reaching resources outside defined boundaries, **even if a prompt injection bypasses Claude's decision-making.**
> Filesystem restrictions in the sandbox combine the `sandbox.filesystem` settings with Read and Edit deny rules; both are merged into the final sandbox boundary.

**Judgment for the config decision:** a `tools: Read, Grep, Glob` grant is a genuine structural constraint on file access — no shell, no arbitrary reads. Adding `Bash` removes that: file reads become the default-allowed case, path deny rules are partial (recognized commands only, best-effort elsewhere), and only sandboxing restores an enforced boundary. If the `adversary` agent's read-scope limitation is load-bearing for the information-asymmetry property, do not grant it `Bash` without sandboxing.

---

## Summary table

| Claim | Verdict | Basis |
| :-- | :-- | :-- |
| C1 namespacing | CONFIRMED (namespacing) / REFUTED (non-shadowing) | S1 scope table (plugin = priority 5, lowest; higher-priority location wins on same name); S2 namespacing statement |
| C2 precedence & override | CONFIRMED for precedence; PARTIAL for override | S1 priority table + managed-precedence + "copy the agent file into `.claude/agents/`"; no documented way to make a scoped plugin agent unreachable |
| C3 `${CLAUDE_PLUGIN_ROOT}` | CONFIRMED (failure shape undocumented) | S2 substitution table is plugin-component-scoped; zero mentions in S1; G5 shows empty expansion when unresolvable |
| C4 frontmatter schema | CONFIRMED | S1 "Supported frontmatter fields"; S2 plugin-agent subset |
| C5 missing final report | CONFIRMED as reproduced defect; causes NOT established; docs silent | G1 (14–30% rate, `completed` with no `<result>`, `stop_reason: None`), G2, G3, G4; S4 covers only the API-error variant |
| C6 Bash bypass | CONFIRMED | S3 read-only command set, "don't apply to arbitrary subprocesses", `Bash(command:…)` bypassability, sandboxing section |
