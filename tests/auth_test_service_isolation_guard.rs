//! Guard: no in-process auth test may reach the keychain under the real `jr-jira-cli` service.
//!
//! `jr` falls back to the service name `jr-jira-cli` when `JR_SERVICE_NAME` is unset, so a test
//! that calls `handle_login`, `handle_logout`, `handle_remove` or `refresh_credentials` directly
//! without setting a test service name can read, write or delete entries in a developer's real
//! keychain. This test reads the other files under `tests/` and fails for every test function
//! that makes one of those calls without one of:
//!
//! - setting `JR_SERVICE_NAME` in its own body, or
//! - calling a helper in the same file whose own body sets `JR_SERVICE_NAME`.
//!
//! Scope: it covers those in-process calls. Tests that spawn the `jr` binary are not checked
//! here. It scans source text only: it runs no `jr` command and touches no keychain.

use std::collections::BTreeSet;
use std::path::Path;

/// Library calls that reach the keychain.
const KEYCHAIN_REACHING_CALLS: &[&str] = &[
    "handle_login(",
    "handle_logout(",
    "handle_remove(",
    "refresh_credentials(",
];

fn reaches_keychain(text: &str) -> bool {
    KEYCHAIN_REACHING_CALLS.iter().any(|p| text.contains(p))
}

/// One `fn` item: its name, whether it is a test, and its text up to the next `fn`.
struct Segment {
    name: String,
    is_test: bool,
    text: String,
}

fn fn_name(line: &str) -> Option<String> {
    let t = line.trim_start();
    let t = t.strip_prefix("pub ").unwrap_or(t);
    let t = t.strip_prefix("async ").unwrap_or(t);
    let t = t.strip_prefix("unsafe ").unwrap_or(t);
    let rest = t.strip_prefix("fn ")?;
    let name: String = rest
        .chars()
        .take_while(|c| c.is_alphanumeric() || *c == '_')
        .collect();
    if name.is_empty() { None } else { Some(name) }
}

fn segments(source: &str) -> Vec<Segment> {
    let lines: Vec<&str> = source.lines().collect();
    let mut starts = Vec::new();
    for (i, line) in lines.iter().enumerate() {
        if let Some(name) = fn_name(line) {
            // Walk back over attribute and comment lines to see whether this is a test.
            let mut is_test = false;
            let mut j = i;
            while j > 0 {
                let prev = lines[j - 1].trim();
                if prev.starts_with("#[") || prev.starts_with("//") || prev.is_empty() {
                    if prev.starts_with("#[test") || prev.starts_with("#[tokio::test") {
                        is_test = true;
                    }
                    j -= 1;
                } else {
                    break;
                }
            }
            starts.push((i, name, is_test));
        }
    }
    let mut out = Vec::new();
    for (k, (i, name, is_test)) in starts.iter().enumerate() {
        let end = starts.get(k + 1).map(|s| s.0).unwrap_or(lines.len());
        out.push(Segment {
            name: name.clone(),
            is_test: *is_test,
            text: lines[*i..end].join("\n"),
        });
    }
    out
}

/// Names of the tests in `source` that reach the keychain without a test service name.
fn offenders(source: &str) -> Vec<String> {
    let segs = segments(source);
    let isolating_helpers: BTreeSet<&str> = segs
        .iter()
        .filter(|s| !s.is_test && s.text.contains("JR_SERVICE_NAME"))
        .map(|s| s.name.as_str())
        .collect();
    segs.iter()
        .filter(|s| s.is_test)
        .filter(|s| reaches_keychain(&s.text))
        .filter(|s| {
            let isolated = s.text.contains("JR_SERVICE_NAME")
                || isolating_helpers
                    .iter()
                    .any(|h| s.text.contains(&format!("{h}(")));
            !isolated
        })
        .map(|s| s.name.clone())
        .collect()
}

#[test]
fn test_guard_flags_a_test_that_reaches_the_keychain_without_a_service_name() {
    let src = r#"
#[test]
fn bare() {
    let r = handle_login(args);
}

#[test]
fn scoped() {
    unsafe { std::env::set_var("JR_SERVICE_NAME", "x") };
    let r = handle_login(args);
}

fn helper() -> Command {
    let mut c = Command::cargo_bin("jr").unwrap();
    c.env("JR_SERVICE_NAME", "x");
    c
}

#[test]
fn via_helper() {
    helper().args(["auth", "list"]).output().unwrap();
}

#[test]
fn unrelated() {
    assert_eq!(1 + 1, 2);
}
"#;
    assert_eq!(offenders(src), vec!["bare".to_string()]);
}

#[test]
fn test_every_auth_test_runs_under_a_test_service_name() {
    let dir = Path::new(env!("CARGO_MANIFEST_DIR")).join("tests");
    let mut found = Vec::new();
    for entry in std::fs::read_dir(&dir).unwrap() {
        let path = entry.unwrap().path();
        if path.extension().and_then(|e| e.to_str()) != Some("rs") {
            continue;
        }
        if path.file_name().and_then(|n| n.to_str()) == Some("auth_test_service_isolation_guard.rs")
        {
            continue;
        }
        let source = std::fs::read_to_string(&path).unwrap();
        for name in offenders(&source) {
            found.push(format!(
                "{}::{}",
                path.file_name().unwrap().to_string_lossy(),
                name
            ));
        }
    }
    assert!(
        found.is_empty(),
        "these tests reach the keychain without JR_SERVICE_NAME, so they would use the real \
         `jr-jira-cli` service; set a test service name (see `unique_service`): {found:#?}"
    );
}
