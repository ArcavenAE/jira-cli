# Phase F6 — Fuzz Assessment (field-dx delta)

- **Producer:** formal-verifier (Phase F6 targeted hardening)
- **Branch / commit:** `develop` @ `4e4ae4f540ed04e652ced2cf113e11f851fe6d34`
- **Scope:** field-dx bundle (issues #578, #580)
- **Information-asymmetry wall (DF-025):** No Phase F5 adversarial-review artifact was read. Input surfaces were derived independently from the VP catalog and source.

---

## 1. Fuzz availability finding

**`cargo-fuzz` / a `fuzz/` harness directory is NOT set up in this repository.** Verified:

- No `fuzz/` directory at repo root (`ls fuzz` → "No such file or directory").
- No `cargo-fuzz` / `fuzz_target!` usage anywhere (`grep -rn -i "cargo-fuzz\|fuzz_target" Cargo.toml src tests` → 0 hits).
- No libFuzzer/AFL wiring in `.cargo/`.

### Justified substitution → proptest arbitrary-input generators

The repo's recorded methodology (CLAUDE.md: "Property tests with proptest";
`verification-delta-field-dx.md §0`) uses **proptest with arbitrary-input strategies** as
the coverage mechanism for parser/input-handling surfaces, in place of a standalone
coverage-guided fuzzer. For the field-dx input-parsing surfaces this substitution is sound:

- Each parsing surface is exercised through a proptest that generates **arbitrary Unicode
  input** (`\PC{0,80}` — any Unicode scalars incl. multibyte — and `[^\x00]{0,24}`
  arbitrary-non-NUL), which is precisely the class of input a byte-oriented fuzzer would
  target (multibyte-boundary panics, embedded delimiters, empty segments).
- The properties assert the two invariants a fuzzer would look for: **no panic**
  (no `exit 101`, no `"panicked at"` in stderr) and **no malformed output**
  (every emitted PUT/POST body is valid JSON).
- The surfaces are pure/near-pure string transforms with bounded input; a coverage-guided
  fuzzer offers little marginal reach over exhaustive proptest shrinking here.

A standalone `cargo-fuzz` target could be added later for continuous long-running fuzzing,
but is **not required** to close the field-dx input surfaces at F6 — each already has
arbitrary-input property coverage.

---

## 2. Input-surface → proptest coverage

The three input-parsing surfaces named in the F6 task, each with its arbitrary-input proptest:

| Input surface | Parser / composer | Arbitrary-input proptest | Strategy | Panic-free assertion |
|---|---|---|---|---|
| `NAME[:kind]=VALUE` splitting | `parse_field_kv` (`src/cli/issue/create.rs:564`) | `prop_field_hint_split_no_panic` (create.rs:1140); `prop_field_hint_value_bytes_preserved` (1221); `prop_parse_field_kv_no_panic_on_arbitrary_input` (1123) | `raw in "\PC{0,80}"` (any Unicode scalars); value `in "\PC{0,40}"` | returns `Ok`/`Err(UserError)`, never unwinds; VALUE preserved byte-for-byte |
| `WS:OBJ` asset parsing | `:asset` composer / `resolve_asset_field_l2` (`field_resolve.rs`), first-colon `split_once(':')` | `prop_asset_composer_no_malformed_json_ever` (`tests/issue_field_hint_kinds.rs:1150`) | `prop_oneof![5 => "[^\x00]{0,24}", 2 => "[0-9]{1,10}"]` (arbitrary non-NUL + numeric objectId lane so the PUT-body branch actually executes) | no `exit 101`, no `"panicked at"`; every PUT body is valid JSON |
| `Parent>Child` cascading `>` split | `:option` composer, `str::split_once('>')` (`field_resolve.rs`, `create.rs`) | `prop_cascading_split_no_panic` (`tests/issue_field_hint_kinds.rs:470`) | `val in "[^\x00]{0,24}"` (arbitrary non-NUL) | no `exit 101`, no `"panicked at"` |

**Bug-class provenance:** these proptests are the direct mitigation of `FIX-F6-LRE-1` (#734)
— the byte-offset-slice-inside-a-multibyte-scalar panic class (the same defect
`validate_duration::split_at` had on `"7é"`). The delta's split sites use char-boundary-safe
`split_once`, and the proptests pin no-panic over multibyte input; both `>` and `:` split
sites have a dedicated arbitrary-UTF-8 no-panic proptest per the VP-578-008 (D3) and
VP-578-012 (Pass2-F3) extensions.

### Coverage verdict

- **All three named input surfaces have arbitrary-input proptest coverage.** No input surface
  is left without a property test.
- Proptests are subprocess-based (spawn the real `jr` binary) and assert against real panic
  signals (`exit 101`, `"panicked at"`), giving genuine end-to-end panic detection equivalent
  to a fuzzer's crash oracle.

---

## 3. Execution

The field-dx proptests run as part of the full `cargo test` suite on `develop` @ `4e4ae4f5`:

- **Full suite: PASS — exit 0; 4660 passed, 0 failed, 106 ignored** (across 111 result lines).
- All three input-surface proptests executed and passed:
  - `prop_field_hint_split_no_panic` + `prop_field_hint_value_bytes_preserved` (`parse_field_kv`),
  - `prop_cascading_split_no_panic` (`Parent>Child` split),
  - `prop_asset_composer_no_malformed_json_ever` (`WS:OBJ` asset composer).

No proptest (parser, cascading-split, or asset-composer) reported a panic or shrink failure.

---

## 4. Fuzz-substitution justification — summary

- **cargo-fuzz / fuzz/ present:** No.
- **Substitution justified:** **Yes** — proptest arbitrary-Unicode-input generators cover
  every field-dx input-parsing surface (`parse_field_kv`, `WS:OBJ` asset split,
  `Parent>Child` cascading split) with no-panic + no-malformed-JSON oracles, which is the
  coverage a byte-oriented fuzzer would target for these bounded pure-string transforms.
- **Uncovered input surface:** **None.**
