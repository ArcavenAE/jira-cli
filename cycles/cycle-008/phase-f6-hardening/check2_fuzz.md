# Check 2 — Fuzz / arbitrary-input totality

VERDICT: JUSTIFIED SKIP (new input surface is total-by-construction; boundary classes unit-tested; arbitrary-byte parser is pre-existing/unchanged/out-of-delta)

## New input surface introduced by the delta
- classify_401_body(message: &str, hint: &str): the only NEW function that "ingests" a 401 body.
  BUT it does not parse bytes — it receives an already-decoded &str (the output of
  extract_error_message). Its handling is a single case-insensitive `.contains()` + variant
  construction: cannot panic for any &str (see check1). Boundary/adversarial input classes are
  already exercised by unit tests: empty string, near-miss substrings, case variants, wire-embedded
  substring.

## The actual arbitrary-byte surface
- extract_error_message(&[u8]) is what turns arbitrary Jira 401 response bytes into a String. That
  function is PRE-EXISTING and UNCHANGED in this delta (git diff shows it untouched; classify_401_body
  was extracted to sit downstream of it). It is out of the cycle-008 delta scope.
- The delta only changed WHICH JrError variant a 401 maps to, and made the post-refresh retry-401
  handler read+classify the retry body instead of hardcoding NotAuthenticated. No new byte parsing.

## Conclusion
No fuzz campaign run. Justified: (1) the new function is a total &str classifier with unit coverage
of the adversarial input classes; (2) the arbitrary-byte ingestion (extract_error_message) is
unchanged and outside the delta. A libFuzzer/cargo-fuzz target would exercise pre-existing code, not
the delta. No panic vector introduced by cycle-008.
