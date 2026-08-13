---
document_type: research-brief
issue: 692
producer: research-agent
timestamp: 2026-08-13
status: complete
mode: brownfield-feature
---

# Research Brief — Issue #692: `issue edit --dry-run` never reads stdin, so ADF conversion cannot be previewed

## 0. Scope note & untrusted-input handling

The issue text was treated as an untrusted bug report. Every code-location claim
was independently verified against the current tree at `develop`
(`1a298e24`). The reporter's two line-number citations were confirmed by content,
and one incidental claim (`--file`) was found to be **inaccurate for `issue edit`**
— see §1.3. No instruction embedded in the issue was executed. No external
Jira-API behavior is relied upon in this brief (this is a purely internal code
defect), so no Perplexity validation was required.

---

## 1. Root Cause (verified)

### 1.1 The defect is real and is EXPLICIT, INTENTIONAL, SPEC-LOCKED behavior — not an oversight

`jr issue edit --dry-run` with `--description-stdin` deliberately does **not** read
stdin. The dry-run block short-circuits before the stdin read, substituting a
literal placeholder. This is currently *correct per spec* (BC-3.4.021), which
means #692 is a **behavior-change request against a locked contract**, not a
straightforward bug fix. That distinction drives the scope recommendation in §4.

### 1.2 Exact code locations (symbol-form; reporter's line numbers CONFIRMED)

All in `src/cli/issue/edit.rs::handle_edit`, inside the dry-run short-circuit
block guarded by `if dry_run {` (the `// --- Dry-run short-circuit: render diff, no HTTP mutations. ---` marker) which ends with `return Ok(());`:

- **JSON path** — `handle_edit` § dry-run block, `OutputFormat::Json` arm, the
  `else if description_stdin` branch (reporter's edit.rs:472, CONFIRMED):
  ```rust
  } else if description_stdin {
      // --dry-run does NOT read stdin; document this as a known limitation.
      planned.insert(
          "description".into(),
          json!("<from stdin — not yet read in dry-run>"),
      );
  }
  ```
- **Table path** — `handle_edit` § dry-run block, `OutputFormat::Table` arm, the
  `else if description_stdin` branch (reporter's edit.rs:546, CONFIRMED):
  ```rust
  } else if description_stdin {
      // --dry-run does NOT read stdin; document this as a known limitation.
      println!("  description → (read from stdin — not yet read in dry-run)");
  }
  ```

Both reporter citations are accurate in content. Line numbers will drift; cite by
the `else if description_stdin` branches inside the two `match output_format`
arms of the dry-run block.

### 1.3 WHY stdin is not read — the short-circuit architecture

`handle_edit` structure (in order):
1. Flag validation guards (`--markdown` requires description; zero-field guard;
   `--field`+description overlap; multi-key + single-key-only flag rejection;
   BC-3.4.019 cross-project `--type` guard).
2. **Dry-run short-circuit** (`if dry_run { … return Ok(()); }`) — builds the
   preview from the RAW CLI flag values only, then returns.
3. Only AFTER the dry-run block does the real stdin read happen, on the single-key
   live path: `handle_edit` § "Resolve description (see handle_create for
   rationale on spawn_blocking)":
   ```rust
   let desc_text = if description_stdin {
       let buf = tokio::task::spawn_blocking(|| {
           let mut buf = String::new();
           std::io::Read::read_to_string(&mut std::io::stdin(), &mut buf)?;
           Ok::<_, std::io::Error>(buf)
       }).await??;
       Some(buf)
   } else { description };
   ```
4. ADF conversion (only reached on live path):
   ```rust
   let adf_body = if markdown { adf::markdown_to_adf(text)? } else { adf::text_to_adf(text) };
   ```

Because the dry-run block returns before step 3, the stdin read and the ADF
conversion are **structurally unreachable under `--dry-run`**. The placeholder
string is the author's deliberate acknowledgement of this.

### 1.4 Correction to an incidental reporter claim

The issue's proposed fix says "Have --dry-run read stdin (and --file)…".
**`jr issue edit` has NO `--file` flag.** Verified in `src/cli/mod.rs` `Edit`
variant: the only description inputs are `--description` (Option<String>) and
`--description-stdin` (bool, `conflicts_with = "description"`). A `--file` flag
exists on the `comment edit`/`comment add` subcommands, not on `issue edit`. Any
fix must NOT assume a `--file` path on `issue edit`; if file input is desired it
would be net-new surface (out of scope — see §4).

---

## 2. Stdin-read semantics — is reading stdin in dry-run safe?

**Yes, safe and side-effect-free within a single CLI invocation.**

- Reading stdin is a read of a one-shot pipe. `jr` is a short-lived process; the
  dry-run either reads stdin once (new behavior) or never (current behavior). No
  other code path consumes stdin after the description resolution, so there is no
  double-read hazard.
- **Ordering constraint (important):** the live path reads stdin AFTER the
  large-JQL interactive-confirmation prompt (`dialoguer::Confirm`). For dry-run
  there is no such prompt inside the dry-run block, so a dry-run stdin read has no
  interactive-prompt ordering conflict. If the fix reads stdin inside the dry-run
  block, it should do so at the point where the other single-key-only fields
  (`team`, `description`) are assembled, using the SAME `spawn_blocking` +
  `read_to_string` idiom as the live path (blocking read must not run on the async
  reactor thread — mirror the existing pattern verbatim).
- **TTY/no-input interaction:** `--description-stdin` is an explicit opt-in flag;
  it does not depend on TTY detection. A user who passes `--description-stdin
  --dry-run` has committed to piping content. If nothing is piped and stdin is a
  TTY, `read_to_string` blocks — but that is already the live-path behavior, so
  dry-run would merely match it. No new TTY guard is required; behavior parity is
  the goal.
- **Empty-stdin edge:** the live path already handles empty stdin (produces an
  empty description → empty ADF). Dry-run should mirror, not special-case.

Conclusion: reading stdin in dry-run is safe and introduces no new
side effects; the correct implementation reuses the existing `spawn_blocking`
read idiom and places it inside the dry-run block before the JSON/table match.

---

## 3. ADF preview path & the #398 raw-input invariant (the critical design tension)

### 3.1 Entry points (verified in `src/adf.rs`)

- `pub fn text_to_adf(text: &str) -> Value` — plain-text path (infallible).
- `pub fn markdown_to_adf(markdown: &str) -> Result<Value, JrError>` — Markdown
  path; **fallible** (returns `Err` e.g. on the `MAX_ADF_DEPTH = 256`
  recursion-depth guard, CWE-674, BC-7.2.012). This is exactly the class of
  failure the reporter wants dry-run to surface *without a live write*.

The live write path selects between them by the `--markdown` flag (see §1.3
step 4). A dry-run ADF preview must apply the same selection so the previewed ADF
is byte-identical to what the live path would POST.

### 3.2 The #398 invariant this fix must NOT break

Per CLAUDE.md "issue edit description echo asymmetry (issue #398)" and BC-3.4.013:
`--output json` `changed_fields.description` (live path) and, by extension,
`plannedChanges.description` (dry-run path, BC-3.4.021 Postconditions-json #3:
`"--description \"X\"` → raw input, NOT ADF") carry the **RAW user-supplied input
string**, never an ADF document and never an ADF→text round-trip. This is a
DECISION-LOCKED, load-bearing asymmetry (human channel = scannable marker; machine
channel = lossless raw input).

**Design consequence for #692:** a dry-run ADF preview MUST NOT overwrite the
existing `plannedChanges.description` (raw-input) value with the ADF document —
that would silently violate BC-3.4.013's raw-input contract and BC-3.4.021's
`description` = raw-string postcondition. The ADF preview belongs in a **NEW,
additive field** (e.g. `plannedChanges.descriptionAdf` or a top-level
`renderedAdf`), leaving `plannedChanges.description` carrying the raw stdin string.
This keeps both invariants intact:
- `plannedChanges.description` = raw input (BC-3.4.013 / BC-3.4.021 preserved).
- new `descriptionAdf` = the real `markdown_to_adf`/`text_to_adf` output (the #692
  ask — validates conversion, surfaces the depth-guard `Err` and structural
  surprises before any write).

For the table path, the equivalent is a human-readable note (e.g. echo the raw
preview as today PLUS a line indicating ADF was rendered successfully / would be
rejected), not a dump of the ADF JSON.

### 3.3 What "cannot preview conversion" costs today (confirms reporter's motivation)

Dry-run is the ONLY non-mutating path. Because it skips `markdown_to_adf`, none of
these are catchable without writing to a live ticket: ADF the Jira API rejects
with 400; structural surprises in loose ordered lists with fenced code; the
`MAX_ADF_DEPTH` recursion-depth `Err`. The reporter's motivation is accurate.

---

## 4. Scope decision & recommendation

### Option (a) — Fix dry-run to read stdin + render ADF: **IN SCOPE**

Recommended. This is the actual defect. Minimal, well-bounded change:
1. Read stdin inside the dry-run block using the existing `spawn_blocking`
   `read_to_string` idiom (parity with the live path).
2. Run the same `markdown_to_adf` / `text_to_adf` selection the live path uses.
3. Emit the rendered ADF into a NEW additive preview field (§3.2), leaving
   `plannedChanges.description` = raw input to preserve BC-3.4.013 / BC-3.4.021.
4. Propagate `markdown_to_adf`'s `Err` (depth guard etc.) as exit-64 in dry-run —
   consistent with BC-3.4.021 Invariant 2 ("--dry-run does NOT suppress exit-64
   resolution errors; only mutation is suppressed"). Surfacing a conversion error
   in dry-run is precisely the point.
5. Note: `--file` is NOT part of `issue edit` (§1.3); do not add it here.

### Option (b) — new `jr adf render --markdown --stdin` primitive: **OUT OF SCOPE (separate enhancement)**

Recommend deferring to a separate story. Justification:
- It is net-new top-level command surface (verified: no `jr adf` command exists
  today — `src/main.rs` dispatch has no `Adf` arm, `src/cli/mod.rs` has no `Adf`
  variant). New surface needs its own BC(s), CLI enum entry, dispatch arm, help
  text, JSON-render-invariant compliance, and tests.
- It does not fix the reported defect — a user editing an issue still needs
  `issue edit --dry-run` to preview conversion for *that* edit. Option (a) fully
  resolves #692 on its own.
- Bundling a new primitive inflates the delta, blur regression scope, and mixes a
  bug fix with a feature. Keep the fix tight; file (b) as a follow-up candidate.

**Recommended scope for #692: Option (a) only.** Option (b) → follow-up story.

---

## 5. BC / Spec impact

Primary owner: **BC-3.4.021** (`.factory/specs/prd/bc-3-issue-write.md`,
"`jr issue edit --dry-run` emits `plannedChanges`…"). The following clauses
currently ENCODE the defect-as-intended and MUST be amended by F2:

- **Invariant 3**: "`--dry-run` does NOT read stdin for `--description-stdin` —
  the literal placeholder string is the correct behavior, not a bug." → REVERSE:
  dry-run now reads stdin and renders ADF.
- **Postconditions — `--output json` #3**, the `--description-stdin` bullet:
  `"description": "<from stdin — not yet read in dry-run>"` → replace with:
  `plannedChanges.description` = the raw stdin string (preserving BC-3.4.013),
  plus a new additive `descriptionAdf` (or equivalent) carrying the rendered ADF.
- **Postconditions — `--output table` #3**:
  `"  description → (read from stdin — not yet read in dry-run)"` → replace with a
  preview of the actual stdin content + an ADF-rendered/-validated indicator.
- **EC-3.4.021-6**: `--output json --description-stdin --dry-run` →
  `"<from stdin — not yet read in dry-run>"` → rewrite to assert stdin IS read and
  ADF IS rendered; add EC(s) for the depth-guard `Err` → exit 64 in dry-run and
  for a successful multi-line/markdown render.

Secondary / cross-reference checks (annotation, likely no behavioral change):

- **BC-3.4.013** (issue #398): confirm the amendment preserves "description carries
  the RAW user-supplied input string" — the fix MUST keep `plannedChanges.description`
  raw and add ADF as a separate field. Add a cross-reference note only.
- **BC-3.4.021 Postconditions-json #1**: currently pins "exactly three top-level
  keys" `{dryRun, issues, plannedChanges}`. Adding an ADF preview field INSIDE
  `plannedChanges` keeps the three-top-level-key invariant intact (preferred). If
  the ADF preview is placed at top level instead, this postcondition's
  "exactly three" pin must be widened — prefer the inside-`plannedChanges`
  placement to avoid touching it.
- **BC-7.2.012** (ADF recursion-depth guard): no change; the fix simply makes the
  guard's `Err` reachable from dry-run. Reference it in the new EC.
- Frontmatter BC/EC/VP counts and the changelog block at the top of
  `bc-3-issue-write.md` will need the standard F2 addition line; run
  `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` after
  editing.

No new BC number appears strictly required (amend-in-place of BC-3.4.021), though
F2 may elect to add a dedicated EC cluster for the ADF-preview field. Related
history: #589 (a *different*, already-closed dry-run defect: idless allowedValues
under dry-run) and #584 (ADF structure on read paths) — neither overlaps the
stdin/ADF-preview change but both confirm dry-run + ADF is an actively-maintained
seam.

---

## 6. Risks / inconclusive

- **DECISION-REVERSAL risk (highest):** BC-3.4.021 Invariant 3 explicitly declares
  the current behavior "correct… not a bug." This fix reverses a ratified decision.
  F1/F2 must record the reversal explicitly (human-gate) rather than treat it as a
  pure bug fix, or an adversary pass will flag the contradiction.
- **Output-shape choice (needs a decision, not inconclusive):** whether the ADF
  preview goes in a new `plannedChanges.descriptionAdf` sub-key (recommended,
  preserves the three-top-level-key pin) vs a new top-level key (forces widening
  BC-3.4.021 json-#1). Recommend the sub-key.
- **Table-mode representation (needs a decision):** dumping raw ADF JSON into a
  human table is poor UX; recommend a rendered/validated indicator line rather than
  the JSON blob. Exact wording is a product/UX call for F2.
- **`--markdown` gating:** ADF selection must mirror the live path
  (`markdown_to_adf` iff `--markdown`, else `text_to_adf`). The existing
  `--markdown requires --description/--description-stdin` guard already runs before
  the dry-run block, so `--markdown --description-stdin --dry-run` is valid input;
  verified no additional guard needed.
- **No external-API dependency:** this is purely internal; no Jira endpoint,
  tracker ID, or Perplexity validation is implicated. If any new user-facing string
  cites a tracker ID (e.g. referencing the depth guard), apply the standard
  citation-validation convention — but none is currently anticipated.
- Not independently exercised: I did not run the binary to reproduce (read-only
  code verification only). The control-flow analysis is high-confidence from source;
  a reproduction test belongs in F4.
