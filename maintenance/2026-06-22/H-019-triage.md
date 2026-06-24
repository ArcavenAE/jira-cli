# H-019 Triage: Profile Name `foo:bar` Exit-Code Drift

**Date**: 2026-06-22
**Finding ref**: H-019-EXIT-DRIFT (holdout-freshness sweep 2026-06-22)
**Triage verdict**: REAL-BUG

---

## Summary of the Discrepancy

H-019 asserts all three "invalid profile name `foo:bar`" boundaries exit **64** (EX_USAGE).
The actual build behavior observed during the sweep:

| Boundary | Observed exit | H-019 expects |
|---|---|---|
| (a) `--profile foo:bar` flag | **78** | 64 |
| (b) `[profiles."foo:bar"]` in config.toml | **64** | 64 |
| (c) `JR_PROFILE=foo:bar` env var | **78** | 64 |

Boundaries (a) and (c) exit 78 instead of 64. The holdout is right; the implementation has a bug.

---

## Root Cause Analysis

### `validate_profile_name` returns the wrong error variant for charset violations

`src/config.rs::validate_profile_name` (lines 114–142) has two distinct charset/length checks,
and they emit **different** `JrError` variants:

1. **Empty or too-long names** (line 123–127):
   ```rust
   return Err(JrError::ConfigError(
       "Profile name too long (max 64 characters)".to_string(),
   ));
   ```
   Exits **78** (EX_CONFIG). `JrError::ConfigError` → `exit_code() == 78`.

2. **Invalid charset** (line 129–136) — this is the branch hit by `foo:bar`:
   ```rust
   return Err(JrError::ConfigError(
       "Profile name contains invalid characters (use a-z, 0-9, -, _)".to_string(),
   ));
   ```
   Also exits **78** (EX_CONFIG). Also `JrError::ConfigError`.

3. **Reserved Windows names** (line 138–140): falls through to `invalid_profile_name()` which
   correctly returns `JrError::UserError` → exit **64**.

So for `foo:bar` (a colon is an invalid charset character), `validate_profile_name` hits the
charset branch and returns `JrError::ConfigError`, which exits 78.

### Where `validate_profile_name` is called for boundaries (a) and (c)

The call at `src/config.rs::load_inner` line 321:

```rust
validate_profile_name(&active_profile_name)?;
```

This `?` propagates the `JrError::ConfigError("Profile name contains invalid characters…")` directly
as an `anyhow::Error`, which exits 78. The `active_profile_name` here was resolved from either
the `--profile` flag or `JR_PROFILE` env var — so both boundaries (a) and (c) hit this path.

### Why boundary (b) exits 64

For the config-file boundary (`[profiles."foo:bar"]`), the call is at lines 291–299:

```rust
for name in global.profiles.keys() {
    validate_profile_name(name).map_err(|_| {
        JrError::UserError(format!(
            "invalid profile name {name:?} in config.toml; …"
        ))
    })?;
}
```

Here `validate_profile_name`'s return value is thrown away and **replaced** by a fresh
`JrError::UserError(…)` via `.map_err(|_| …)`. So regardless of what variant
`validate_profile_name` returns, the config-file boundary always produces `UserError` → exit 64.

---

## Which Contract Is Correct?

**Exit 64 (EX_USAGE) is correct for all three boundaries.** Here is the definitive reasoning:

### Semantic meaning of the two exit codes

From `src/error.rs`:
- `JrError::UserError(_) => 64` — the user supplied bad input (CLI misuse, EX_USAGE)
- `JrError::ConfigError(_) => 78` — the config file is malformed or missing (EX_CONFIG)

### The input source is the user, not the file

When the user types `jr --profile foo:bar …` or sets `JR_PROFILE=foo:bar`, the invalid
profile name comes directly from the user's runtime input, not from a config file. The
comment in `src/config.rs` lines 330–334 makes the intent explicit:

> ```
> // UserError (exit 64) instead of ConfigError (exit 78) because the
> // invalid input source is the user (--profile flag, JR_PROFILE env,
> // or a hand-edited default_profile field) — not a malformed config
> // file. Matches the wording used by switch/remove/logout/status.
> ```

This comment governs the "unknown profile" check immediately below it (lines 335–345). The
same rationale applies identically to the charset-validity check at line 321 — if `foo:bar`
comes from the `--profile` flag or `JR_PROFILE`, it is a user error (64), not a config error
(78).

The code at line 321 propagates `validate_profile_name`'s raw error, which for charset
violations is `JrError::ConfigError` — contradicting the explicit design intent documented
four lines below.

### Consistency with existing behavior and CLAUDE.md

The config-file boundary (b) already uses the `.map_err(|_| JrError::UserError(…))` wrapper
to ensure exit 64. The flag/env boundaries should do the same.

`JrError::ConfigError` is semantically correct for: "the installed config.toml is unreadable
or has a structurally broken key." It is semantically wrong for: "the user typed an illegal
value on the command line."

---

## Precise Correct Contract

| Boundary | Correct exit code | Correct error variant | Fix needed? |
|---|---|---|---|
| (a) `--profile foo:bar` flag | **64** | `JrError::UserError` | YES — code emits 78 |
| (b) `[profiles."foo:bar"]` in config.toml | **64** | `JrError::UserError` | No — already correct |
| (c) `JR_PROFILE=foo:bar` env var | **64** | `JrError::UserError` | YES — code emits 78 |

---

## What Is Wrong

`validate_profile_name` uses `JrError::ConfigError` for the charset-violation branch. This is
the wrong variant. For empty/too-long and charset violations, the correct variant is
`JrError::UserError` because profile name validation rejects **user-supplied names**, not file
contents. Only the Windows-reserved-names branch (which correctly uses `invalid_profile_name`
→ `UserError`) happens to be right.

The fix is small: in `validate_profile_name`, change both `JrError::ConfigError(…)` returns
to `JrError::UserError(…)` with equivalent messages. The config-file boundary's existing
`.map_err(|_| JrError::UserError(…))` wrapper is then redundant but harmless.

Alternatively (more targeted): wrap the call at line 321 of `load_inner` with a `.map_err`
that converts the `ConfigError` to a `UserError`, mirroring the config-file boundary pattern.
The first approach is cleaner because it makes `validate_profile_name` semantically correct
at its definition.

---

## RECOMMENDATION

**REAL-BUG**

The implementation is wrong for boundaries (a) and (c). The holdout correctly specifies exit 64
for all three boundaries. The root cause is that `validate_profile_name` emits
`JrError::ConfigError` for charset/length violations instead of `JrError::UserError`.

**Follow-up action**: Route to implementer via full VSDD feature-mode pipeline.
Spec change needed: none (BC-6.1.004 intent is clear; the comment in `load_inner` at lines
330–334 already documents the correct contract). The fix is purely in `validate_profile_name`
— change both `JrError::ConfigError(…)` error arms to `JrError::UserError(…)`. Tests
`config_load_rejects_invalid_profile_name_from_env` and
`config_load_rejects_invalid_profile_key_in_config` must be tightened to assert
`matches!(je, JrError::UserError(_))` (currently `config_load_rejects_invalid_profile_name_from_env`
only asserts `result.is_err()` without checking the variant or exit code).
