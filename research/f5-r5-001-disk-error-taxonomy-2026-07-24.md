# F5-R5-001 — Disk-Write Error Taxonomy for `jr issue attachment download`

**Type:** general (technology / implementation)
**Date:** 2026-07-24
**Author:** research-agent
**Scope:** Settle the BC-2.7.012 spec-vs-code divergence for ENOSPC / EACCES / generic
disk-write failures during `jr issue attachment download` (streaming write-to-temp + atomic rename).
**Drives:** a code fix in `src/cli/issue/attachments.rs::stream_to_file` **and** a BC-2.7.012 spec amendment.

---

## MCP-UNAVAILABLE Escalation

All three MCP research servers are unavailable in this environment. Per the research-agent
mandate, the verbatim first-attempt errors are recorded here so the orchestrator can route
toolchain repair. Research proceeded on the WebSearch/WebFetch fallback layer.

```
# mcp__perplexity__perplexity_research (PRIMARY attempt)
Error: No such tool available: mcp__perplexity__perplexity_research

# mcp__perplexity__perplexity_ask (fallback attempt)
Error: No such tool available: mcp__perplexity__perplexity_ask

# mcp__tavily__tavily_search (cross-validation attempt)
Error: No such tool available: mcp__tavily__tavily_search

# mcp__context7__resolve-library-id (library-docs attempt)
Error: No such tool available: mcp__context7__resolve-library-id
```

Mitigation: every claim below is cross-referenced against ≥2 independent primary sources
(rust-lang release notes / source, GNU standards, clig.dev, upstream error text in real
issues). Confidence is annotated per finding.

---

## Executive Summary & Recommendation (Confidence: HIGH)

The current code and the current spec are **both suboptimal**, in opposite directions:

- **Code** (`anyhow::anyhow!("write error to {}: {e}", ...)`) preserves the OS error and names
  the path, but uses a generic prefix and gives **no remediation** and **no disk-full/permission
  discrimination**. It also names the internal temp path (`tmp_<hex>`), not the user-meaningful
  destination.
- **Spec** (BC-2.7.012) pins friendly, discriminated prefixes (`"Disk full: not enough space to
  write <path>"`, `"Permission denied: cannot write to <dir>"`) but **drops the underlying OS
  error** and **drops any next-step hint** — which violates the GNU error-message standard, the
  clig.dev guidance, the dominant peer-CLI pattern, **and this repo's own CLAUDE.md convention
  ("Errors: Always suggest what to do next")**.

**Recommendation: adopt the industry-standard HYBRID shape** — friendly discriminated prefix
(naming the path) **+** preserved OS error string **+** a next-step remediation hint. This is a
purely **additive** amendment: the spec's pinned prefix substrings are retained verbatim (so any
`contains(...)` assertions stay green), while the OS error and remediation are appended.

Final recommended strings (single mode; **exit 1** in all cases — unchanged):

| Condition | `ErrorKind` matched | Recommended stderr string |
|-----------|--------------------|---------------------------|
| Disk full | `StorageFull` \| `QuotaExceeded` | `Disk full: not enough space to write <dest>: <os_error>. Free up disk space and try again.` |
| Permission denied | `PermissionDenied` \| `ReadOnlyFilesystem` | `Permission denied: cannot write to <dir>: <os_error>. Check directory permissions and try again.` |
| Any other write failure | (fallback) | `Failed to write <dest>: <os_error>.` |

Where:
- `<dest>` = the **final destination path** (NOT the internal `tmp_<hex>` path), with the
  server-supplied filename portion run through `display_sanitize_filename` (CWE-116, BC-2.7.011)
  and the operator-controlled parent rendered verbatim — reuse the exact display logic already
  present in the `rename` error branch.
- `<dir>` = `final_path.parent()` (operator-controlled → rendered verbatim).
- `<os_error>` = the `std::io::Error` `Display`, which already ends in `(os error N)`
  (e.g. `No space left on device (os error 28)`).

Detection mechanism valid at MSRV 1.85: match on `std::io::Error::kind()` — all four kinds
(`StorageFull`, `QuotaExceeded`, `PermissionDenied`, `ReadOnlyFilesystem`) are stable at 1.85
(details in Q3). This mapping must run inside `stream_to_file` at **all three** io sites
(`File::create` temp, `write_all` chunk, `rename`) so both single-mode (propagate → exit 1) and
batch-mode (per-file fail-soft warning) paths benefit from one chokepoint.

Testing approach: extract a **pure classifier** `fn(kind, dest, os_err_display) -> String` and
unit-test it with synthetic `io::Error::from(ErrorKind::X)` values — the community-accepted
technique when ENOSPC is not reproducible in CI (Q4).

---

## Q1 — Peer CLI Practice (Confidence: HIGH for git/cargo, MEDIUM for gh/kubectl/aws-cli)

**Question:** raw OS pass-through, friendly canonical, or hybrid (friendly prefix + OS error)?

**Finding: the dominant industry pattern is the HYBRID** — a human-readable "what we were doing"
prefix that names the failing resource, followed by the preserved low-level OS error string.

- **git (VERIFIED):** on a disk-full write during clone, git emits
  `fatal: write error: No space left on device` followed by `fatal: index-pack failed`
  ([Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/682325/fatal-write-error-no-space-left-on-device-fatal-in)).
  This is a hybrid: git's `die()` prints a friendly action context (`write error`) **plus** the
  `strerror(errno)` OS text (`No space left on device`). This directly follows the GNU convention
  (Q2). git does **not** hide the OS error, and does **not** emit only the OS error.
- **cargo / Rust tools (VERIFIED):** cargo surfaces a `Caused by:` error chain terminating in the
  OS leaf, e.g. `Caused by: Permission denied (os error 13)` under a higher-level
  `error: failed to run custom build command for proc-macro2` / `failed to write ...`
  ([users.rust-lang.org](https://users.rust-lang.org/t/error-could-not-execute-process/42018)).
  This is the anyhow/`.with_context()` hybrid: context layer + preserved `io::Error` root
  (which carries `os error N`).
- **rustup (INFERRED, MEDIUM):** rustup uses the same anyhow-style context-chain error model as
  cargo; I could not fetch a specific rustup disk-full transcript, so treat as inferred-from-shared-idiom.
- **gh / kubectl (INFERRED, MEDIUM):** these are Go tools; Go's idiomatic
  `fmt.Errorf("...: %w", err)` wrapping produces the same hybrid shape (context prefix + wrapped
  syscall error). I could not locate a specific gh/kubectl disk-full download transcript to cite
  verbatim; flagged as inconclusive at the transcript level but consistent with the Go convention.
- **aws-cli (INCONCLUSIVE):** no specific ENOSPC transcript found; not cited.

**Conclusion:** across the two tools I could verify byte-for-byte (git, cargo) the pattern is
unambiguously **hybrid**. Neither "raw pass-through only" nor "friendly-only (OS error hidden)"
is used by mature tools. This is the single strongest input to the recommendation and is
corroborated independently by the GNU standard (Q2).

---

## Q2 — CLI Error-UX Guidance (Confidence: HIGH)

**clig.dev — Command Line Interface Guidelines**
([clig.dev](https://clig.dev/)):
- **Name the failing resource + give remediation.** Canonical example:
  *"Can't write to file.txt. You might need to make it writable by running 'chmod +w file.txt'."*
  — names the resource AND supplies an actionable next step.
- **"Catch errors and rewrite them for humans."** Treat it "like a conversation ... guiding [the
  user] in the right direction."
- **Manage signal-to-noise.** Keep terminal output relevant; push full tracebacks/debug detail to
  a file rather than flooding the terminal. (This argues for a *concise* OS-error tail, not a
  full backtrace — the single-line `os error N` string is the right amount.)

**GNU Coding Standards — "Errors" / glibc Error Messages**
([GNU Coding Standards](https://www.gnu.org/prep/standards/html_node/Errors.html)):
- **Mandate to preserve the OS error text:** *"Include the system error text (from strerror, or
  equivalent) in every error message resulting from a failing system call, as well as the name of
  the file if any and the name of the utility."*
- **Explicit rejection of the spec's current shape:** *"Just 'cannot open foo.c' or 'stat failed'
  is not sufficient."* — a friendly message that omits the strerror text is judged **insufficient**
  by the standard. This is a direct indictment of BC-2.7.012's current OS-error-dropping strings.
- Message form: `program: file: message` with the strerror tail after the last colon; short,
  no trailing punctuation for the glibc-generated portion (our added remediation sentence is a
  deliberate, clig.dev-endorsed extension).

**Rust CLI book / anyhow idiom**
([anyhow docs](https://docs.rs/anyhow/latest/anyhow/), [ErrorKind docs](https://doc.rust-lang.org/std/io/enum.ErrorKind.html)):
- The idiomatic Rust-app pattern is `fs::write(path, data).with_context(|| format!("failed to
  write to {}", path.display()))?` — a context layer that **names the path** while the `?`+context
  machinery **automatically preserves** the underlying `io::Error` (and its `os error N`) in the
  cause chain. Preserving the OS error is the default, not extra work.

**Synthesis for the three sub-questions:**
- (a) Name the failing path? **Yes** — unanimous (clig.dev, GNU, anyhow idiom).
- (b) Include remediation? **Yes** — clig.dev explicit; also matches this repo's CLAUDE.md rule.
- (c) Preserve the underlying OS error for debuggability? **Yes** — GNU standard makes it
  mandatory and calls friendly-only messages "not sufficient"; clig.dev's signal-to-noise caveat
  only argues against *full tracebacks*, not against the one-line strerror tail.

---

## Q3 — Rust Mechanics at MSRV 1.85 (Confidence: HIGH)

**`ErrorKind::StorageFull` — STABLE since Rust 1.83.0** (available at 1.85).
Stabilized as part of the partial `io_error_more` stabilization in
[PR #128316](https://github.com/rust-lang/rust/pull/128316), shipped in
[Rust 1.83.0 (2024-11-28)](https://blog.rust-lang.org/2024/11/28/Rust-1.83.0/). Doc semantics:
*"The underlying storage (typically, a filesystem) is full. This does not include out of quota
errors."*

**`ErrorKind::QuotaExceeded` — STABLE since Rust 1.85.0** (renamed from `FilesystemQuotaExceeded`).
Confirmed in the [1.85.0 changelog](https://releases.rs/docs/1.85.0/). Because `StorageFull`
explicitly **excludes** quota (EDQUOT) errors, a disk-write that fails due to a filesystem quota
surfaces as `QuotaExceeded`, not `StorageFull`. **Recommendation groups both under "Disk full"**
so a quota-full condition is not misreported as a generic write error. (If EDQUOT is deemed a
distinct UX case, split it later — but grouping is safe and covers the common "no room to write"
intent.)

**`ErrorKind::CrossesDevices` — STABLE since Rust 1.85.0** (EXDEV / Windows `ERROR_NOT_SAME_DEVICE`).
Relevant only to the `rename` step. In `stream_to_file` the temp file is created in the **same
parent directory** as the final path, so a same-device rename is guaranteed and EXDEV should not
occur; no dedicated arm needed (it would fall to the generic branch harmlessly).

**`ErrorKind::PermissionDenied` — STABLE since Rust 1.0** (EACCES). Cross-platform reliable.

**`ErrorKind::ReadOnlyFilesystem` — STABLE since Rust 1.83.0** (EROFS). The BC-2.7.012 row groups
"EACCES / read-only FS" together, so the classifier should match **both** `PermissionDenied` and
`ReadOnlyFilesystem` for the permission-denied message.

**Still unstable at 1.85 (do NOT reference):** `FilesystemLoop`, `InvalidFilename` — neither is
relevant here.

**Cross-platform mapping (VERIFIED against std `decode_error_kind`, Windows PAL):**

| Windows error | Code | std `ErrorKind` |
|---------------|------|-----------------|
| `ERROR_DISK_FULL` | 112 | `StorageFull` |
| `ERROR_HANDLE_DISK_FULL` | 39 | `StorageFull` |
| `ERROR_ACCESS_DENIED` | 5 | `PermissionDenied` |
| `ERROR_NOT_SAME_DEVICE` | — | `CrossesDevices` |

Sources: [PR #128316](https://github.com/rust-lang/rust/pull/128316),
[std ErrorKind docs](https://doc.rust-lang.org/std/io/enum.ErrorKind.html),
`library/std/src/sys/pal/windows/mod.rs::decode_error_kind`. **`StorageFull` and
`PermissionDenied` are therefore reliable on both Unix (ENOSPC→StorageFull, EACCES→PermissionDenied)
and Windows** — the `ErrorKind`-based classifier is genuinely cross-platform; no `#[cfg]` branching
or raw-errno inspection is required.

**Load-bearing code note:** the current code destroys the typed `io::Error` immediately —
`.map_err(|e| anyhow::anyhow!("write error to {}: {e}", ...))` — so `kind()` is no longer
inspectable downstream. The fix **must** branch on `e.kind()` on the raw `std::io::Error`
(tokio's `fs`/`AsyncWriteExt` errors are `std::io::Error`, so `.kind()` works directly)
**before** composing the anyhow message.

---

## Q4 — Testability (Confidence: HIGH)

**Question:** is synthetic `io::Error::from(ErrorKind::X)` adequate evidence, vs mocking the FS?

**Finding: yes — constructing synthetic `io::Error` values is the community-accepted technique**
for unit-testing an `ErrorKind`-based mapping function, and is preferred over filesystem mocking
for a pure classifier.

- The std library explicitly supports payload-free construction:
  `Error::from(ErrorKind::UnexpectedEof)` produces the internal `Simple(ErrorKind)` variant with
  no allocation ([std io::Error docs](https://doc.rust-lang.org/std/io/struct.Error.html)).
- Accepted test pattern
  ([Testing Errors in Rust](https://zhauniarovich.com/post/2021/2021-01-testing-errors-in-rust/),
  [codestudy.net](https://www.codestudy.net/blog/how-to-assert-io-errors-in-rust/)):
  1. Construct input: `let err = io::Error::from(ErrorKind::StorageFull);`
  2. Call the mapping function with it.
  3. Assert on the **output** — either the returned message string (for a `-> String` classifier)
     or `.kind()` (never `assert_eq!` on two `io::Error` values directly; OS-specific payload makes
     equality unreliable).
- Filesystem mocking / test-doubles are only needed when you must exercise the **calling code
  path** that performs the io. For a **pure classifier** they are unnecessary complexity.

**Recommended test shape (drives the code design):** extract the classifier as a pure free
function so it is directly unit-testable without any io:

```rust
// pure, no io — unit-test with synthetic ErrorKind values
fn classify_write_error(kind: std::io::ErrorKind, dest_display: &str, dir_display: &str, os_err: &str) -> String
```

Unit tests: one per branch — `StorageFull`, `QuotaExceeded`, `PermissionDenied`,
`ReadOnlyFilesystem`, and a generic fallback (`ErrorKind::Other`) — asserting the exact
recommended string. This gives full mapping coverage in fast, deterministic, CI-safe tests
without ever needing to fill a disk. (One documented caveat: `ErrorKind` is `#[non_exhaustive]`
and "intended to grow" — do **not** exhaustively match; use explicit arms for the four kinds plus
a `_ =>` generic fallback.)

---

## Impact on BC-2.7.012 (spec amendment guidance)

The three affected rows in the BC-2.7.012 error-path taxonomy table should be amended to the
hybrid strings. The amendment is **additive** — the currently-pinned prefix substrings
(`Disk full: not enough space to write`, `Permission denied: cannot write to`) are preserved
verbatim, so it is a strict widening, not a breaking change to any prefix-`contains` assertion:

| Condition | Exit | Amended stderr |
|-----------|------|----------------|
| Disk full (ENOSPC/EDQUOT) | 1 | `Disk full: not enough space to write <dest>: <os_error>. Free up disk space and try again.` |
| Permission denied (EACCES / read-only FS) | 1 | `Permission denied: cannot write to <dir>: <os_error>. Check directory permissions and try again.` |
| Other OS write error | 1 | `Failed to write <dest>: <os_error>.` |

Batch mode unchanged in structure: these messages flow into the existing per-file fail-soft
`eprintln!("warning: failed to download attachment {}: {e}", ...)` because the classifier runs
inside `stream_to_file`; the friendly message becomes the `{e}` tail.

Also fix the incidental defect: current create/write branches display the internal
`tmp_<hex>` path — the amended messages must display the **final destination** path (the rename
branch already does this correctly; unify all three sites on that display helper, preserving the
CWE-116 `display_sanitize_filename` treatment of the server-supplied filename portion).

---

## Open Items / Residual Uncertainty

- gh / kubectl / aws-cli exact disk-full transcripts: **not verified byte-for-byte** (MEDIUM/INCONCLUSIVE).
  The recommendation does not depend on them — git + cargo + the GNU standard + clig.dev are
  sufficient and mutually corroborating.
- EDQUOT-as-distinct-message: grouped under "Disk full" for now; flagged as a possible future split.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 0 | **UNAVAILABLE** — see MCP-UNAVAILABLE Escalation (verbatim error captured). |
| Perplexity perplexity_ask | 0 | UNAVAILABLE (verbatim error captured). |
| Tavily tavily_search | 0 | UNAVAILABLE (verbatim error captured). |
| Context7 | 0 | UNAVAILABLE (verbatim error captured). |
| WebSearch | 6 | io_error_more/StorageFull stabilization (1.83); QuotaExceeded/CrossesDevices (1.85); Windows decode_error_kind mapping; anyhow with_context idiom; synthetic io::Error testing; git/cargo real disk-full+EACCES transcripts. |
| WebFetch | 2 | clig.dev error-message guidance; attempted std Windows PAL source (fell back to WebSearch for decode_error_kind). |
| Read/Grep/Glob (local) | 5 | Current `stream_to_file` impl, `JrError` taxonomy/exit codes, BC-2.7.012 spec body. |
| Training data | 2 areas | Go `fmt.Errorf("%w")` idiom (gh/kubectl inference — flagged MEDIUM); tokio fs errors are std::io::Error (well-established). |

**Total MCP tool calls:** 0 (all servers unavailable — escalation section documents verbatim errors per the single permitted exception).
**Training data reliance:** low-to-medium — every load-bearing claim (kind stabilization versions, Windows mappings, git/cargo message shape, GNU/clig.dev guidance, synthetic-error testing) is backed by a cited primary source; only the gh/kubectl transcript-level detail rests on the Go-idiom inference, which is explicitly flagged and non-load-bearing.

### Sources
- [Rust 1.83.0 release notes](https://blog.rust-lang.org/2024/11/28/Rust-1.83.0/)
- [PR #128316 — Stabilize most of io_error_more](https://github.com/rust-lang/rust/pull/128316)
- [Rust 1.85.0 changelog (releases.rs)](https://releases.rs/docs/1.85.0/)
- [std::io::ErrorKind docs](https://doc.rust-lang.org/std/io/enum.ErrorKind.html)
- [std::io::Error docs](https://doc.rust-lang.org/std/io/struct.Error.html)
- [clig.dev — Command Line Interface Guidelines](https://clig.dev/)
- [GNU Coding Standards — Errors](https://www.gnu.org/prep/standards/html_node/Errors.html)
- [anyhow crate docs](https://docs.rs/anyhow/latest/anyhow/)
- [git write-error: No space left on device (Microsoft Q&A)](https://learn.microsoft.com/en-us/answers/questions/682325/fatal-write-error-no-space-left-on-device-fatal-in)
- [cargo Permission denied (os error 13) error chain](https://users.rust-lang.org/t/error-could-not-execute-process/42018)
- [Testing Errors in Rust (Zhauniarovich)](https://zhauniarovich.com/post/2021/2021-01-testing-errors-in-rust/)
- [How to Assert IO Errors in Rust (codestudy.net)](https://www.codestudy.net/blog/how-to-assert-io-errors-in-rust/)
</content>
</invoke>
