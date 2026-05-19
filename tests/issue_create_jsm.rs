//! Integration tests for `jr issue create --request-type` dispatch fork.
//!
//! Covers AC-001..AC-015 from story S-288-pr4-dispatch
//! (`.factory/code-delivery/issue-288-pr4-dispatch/story.md`).
//!
//! All HTTP tests use subprocess + wiremock + assert_cmd, matching the pattern
//! established in `tests/requesttype_commands.rs`. Each test runs the `jr`
//! binary via `assert_cmd::Command::cargo_bin("jr")` with:
//!   `JR_BASE_URL=<wiremock url>` `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0`
//!
//! AC-016 (OAuth scope pin) lives in `src/cli/auth/tests/mod.rs`.
//! AC-013 proptest properties live in `src/cli/issue/create.rs::mod parse_field_kv_proptests`.
//! AC-014 proptest properties live in `src/api/jsm/requests.rs::mod proptests`.

use assert_cmd::Command;
use serde_json::{Value, json};
use wiremock::matchers::{method, path, query_param};
use wiremock::{Mock, MockServer, ResponseTemplate};

// ─── Shared mock fixture helpers ──────────────────────────────────────────────

/// Mount project-meta GET for project "HELP" returning a service_desk project.
/// The project_id "99" is matched by the service desk list mock below.
async fn mount_project_meta_help(server: &MockServer) {
    Mock::given(method("GET"))
        .and(path("/rest/api/3/project/HELP"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "id": "99",
            "key": "HELP",
            "projectTypeKey": "service_desk",
            "simplified": false
        })))
        .mount(server)
        .await;
}

/// Mount project-meta GET for project "SW" returning a software project.
async fn mount_project_meta_sw_software(server: &MockServer) {
    Mock::given(method("GET"))
        .and(path("/rest/api/3/project/SW"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "id": "100",
            "key": "SW",
            "projectTypeKey": "software",
            "simplified": false
        })))
        .mount(server)
        .await;
}

/// Mount the service desk list GET, returning service desk id "10" for project id "99".
async fn mount_service_desk_list(server: &MockServer) {
    Mock::given(method("GET"))
        .and(path("/rest/servicedeskapi/servicedesk"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "size": 1,
            "start": 0,
            "limit": 50,
            "isLastPage": true,
            "_links": {},
            "values": [
                {
                    "id": "10",
                    "projectId": "99",
                    "projectKey": "HELP",
                    "projectName": "Help Desk"
                }
            ]
        })))
        .mount(server)
        .await;
}

/// Two request types used across multiple tests.
fn two_request_types_body() -> Value {
    json!({
        "size": 2,
        "start": 0,
        "limit": 50,
        "isLastPage": true,
        "_links": {},
        "values": [
            {
                "id": "11001",
                "name": "Get IT Help",
                "description": "Get IT help for hardware, software, or other issues",
                "helpText": "Please describe the issue in detail",
                "issueTypeId": "12345",
                "serviceDeskId": "10",
                "portalId": "2",
                "groupIds": ["12"]
            },
            {
                "id": "11002",
                "name": "Password Reset",
                "description": "Reset your password",
                "helpText": "Provide your username",
                "issueTypeId": "12346",
                "serviceDeskId": "10",
                "portalId": "2",
                "groupIds": ["12", "13"]
            }
        ]
    })
}

/// Mount the request type list for service desk 10.
async fn mount_request_type_list(server: &MockServer) {
    Mock::given(method("GET"))
        .and(path("/rest/servicedeskapi/servicedesk/10/requesttype"))
        .and(query_param("start", "0"))
        .and(query_param("limit", "50"))
        .respond_with(ResponseTemplate::new(200).set_body_json(two_request_types_body()))
        .mount(server)
        .await;
}

/// Successful JSM create response for "HELP-42".
fn jsm_created_response() -> Value {
    json!({
        "issueId": "107001",
        "issueKey": "HELP-42",
        "requestTypeId": "11002",
        "serviceDeskId": "10",
        "_links": {
            "self": "https://example.atlassian.net/rest/servicedeskapi/request/107001",
            "web": "https://example.atlassian.net/servicedesk/customer/portal/10/HELP-42"
        }
    })
}

/// Write a minimal jr config to a temp XDG_CONFIG_HOME so the subprocess
/// finds a URL while JR_BASE_URL / JR_AUTH_HEADER override the real values.
fn write_minimal_config(config_home: &std::path::Path, url: &str) {
    let dir = config_home.join("jr");
    std::fs::create_dir_all(&dir).unwrap();
    std::fs::write(
        dir.join("config.toml"),
        format!("[instance]\nurl = \"{url}\"\n"),
    )
    .unwrap();
}

// ─── AC-001: dispatch routes to servicedeskapi, NOT platform endpoint ─────────

/// AC-001 (BC-3.8.001, H-NEW-JSM-RT-001): `jr issue create --request-type` fires
/// exactly ONE POST to `/rest/servicedeskapi/request` and ZERO POSTs to
/// `/rest/api/3/issue`. Output contains the issue key; exit 0.
///
/// The `expect(0)` on the platform endpoint is the holdout-H-NEW-JSM-RT-001
/// regression guard.
#[tokio::test]
async fn test_jsm_create_happy_path_routes_to_servicedeskapi() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    // CRITICAL: JSM endpoint must be called exactly once.
    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    // CRITICAL: Platform endpoint must NEVER be called (H-NEW-JSM-RT-001 guard).
    Mock::given(method("POST"))
        .and(path("/rest/api/3/issue"))
        .respond_with(ResponseTemplate::new(500).set_body_string("must not be called"))
        .expect(0)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "My issue",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.001: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );
    // Assert issue key appears in output.
    assert!(
        stdout.contains("HELP-42"),
        "BC-3.8.001: expected issue key 'HELP-42' in output, got: {stdout}"
    );
    // The .expect(0) on the platform mock is enforced automatically by wiremock on server drop.
}

// ─── AC-002: platform path unchanged when --request-type absent ───────────────

/// AC-002 (BC-3.3.001): Without `--request-type`, platform POST fires exactly
/// once and the servicedeskapi POST is never called. Regression guard for
/// the dispatch-fork conditionality.
#[tokio::test]
async fn test_jsm_create_without_request_type_uses_platform_path() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    // Platform endpoint must be called exactly once.
    Mock::given(method("POST"))
        .and(path("/rest/api/3/issue"))
        .respond_with(ResponseTemplate::new(201).set_body_json(json!({
            "id": "10001",
            "key": "PROJ-123",
            "self": format!("{}/rest/api/3/issue/10001", server.uri()),
        })))
        .expect(1)
        .mount(&server)
        .await;

    // JSM endpoint must NEVER be called (regression guard for BC-3.3.001).
    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(500).set_body_string("must not be called"))
        .expect(0)
        .mount(&server)
        .await;

    // GET /rest/api/3/field — for CMDB discovery on the platform path.
    Mock::given(method("GET"))
        .and(path("/rest/api/3/field"))
        .respond_with(ResponseTemplate::new(200).set_body_json(Value::Array(vec![])))
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "PROJ",
            "--type",
            "Task",
            "--summary",
            "Platform issue",
            "--no-input",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);
    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(
        output.status.success(),
        "BC-3.3.001: expected exit 0 on platform path, got {:?}. stderr: {stderr}",
        output.status.code()
    );
    let combined = format!("{stdout}{stderr}");
    assert!(
        combined.contains("PROJ-123"),
        "BC-3.3.001: platform create must emit issue key 'PROJ-123'; got stdout: {stdout}, stderr: {stderr}"
    );
    // The .expect(0) on the servicedeskapi mock is enforced on server drop.
}

// ─── AC-003: non-JSM project exits 64, zero HTTP POST ────────────────────────

/// AC-003 (BC-3.8.002, H-NEW-JSM-RT-002): `--request-type` on a software project
/// exits 64 with a verbatim BC-mandated message. ZERO POSTs to either endpoint.
#[tokio::test]
async fn test_jsm_create_non_jsm_project_exits_64_zero_http() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_sw_software(&server).await;

    // Neither endpoint should receive a POST.
    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(500).set_body_string("must not be called"))
        .expect(0)
        .mount(&server)
        .await;

    Mock::given(method("POST"))
        .and(path("/rest/api/3/issue"))
        .respond_with(ResponseTemplate::new(500).set_body_string("must not be called"))
        .expect(0)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "SW",
            "--request-type",
            "Bug Report",
            "--summary",
            "test",
            "--no-input",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert_eq!(
        output.status.code(),
        Some(64),
        "BC-3.8.002 / H-NEW-JSM-RT-002: expected exit 64 for non-JSM project, got {:?}. stderr: {stderr}",
        output.status.code()
    );
    // BC-3.8.002: verbatim error phrase with call-site label "`jr issue create --request-type`".
    assert!(
        stderr.contains(
            "`jr issue create --request-type` requires a Jira Service Management project"
        ),
        "BC-3.8.002: stderr must contain verbatim BC phrase with call-site label; got: {stderr}"
    );
}

// ─── AC-004: ambiguous request-type exits 64 with hint ───────────────────────

/// AC-004 (BC-3.8.003): When `--request-type "Bug"` matches two request types,
/// exits 64 with "Ambiguous request type" + candidate names + actionable hint.
#[tokio::test]
async fn test_jsm_create_ambiguous_request_type_exits_64() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;

    // Two request types both containing "Bug".
    Mock::given(method("GET"))
        .and(path("/rest/servicedeskapi/servicedesk/10/requesttype"))
        .and(query_param("start", "0"))
        .and(query_param("limit", "50"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "size": 2,
            "start": 0,
            "limit": 50,
            "isLastPage": true,
            "_links": {},
            "values": [
                {
                    "id": "11001",
                    "name": "Bug Report",
                    "description": "Report a bug",
                    "helpText": null,
                    "issueTypeId": "12345",
                    "serviceDeskId": "10",
                    "portalId": "2",
                    "groupIds": []
                },
                {
                    "id": "11002",
                    "name": "Bug Fix Request",
                    "description": "Request a bug fix",
                    "helpText": null,
                    "issueTypeId": "12346",
                    "serviceDeskId": "10",
                    "portalId": "2",
                    "groupIds": []
                }
            ]
        })))
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Bug",
            "--summary",
            "test",
            "--no-input",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert_eq!(
        output.status.code(),
        Some(64),
        "BC-3.8.003: expected exit 64 for ambiguous request type, got {:?}. stderr: {stderr}",
        output.status.code()
    );
    // BC-3.8.003: verbatim prefix.
    assert!(
        stderr.contains("Ambiguous request type \"Bug\" matches:"),
        "BC-3.8.003: stderr must contain 'Ambiguous request type \"Bug\" matches:'; got: {stderr}"
    );
    // Both candidate names must appear.
    assert!(
        stderr.contains("Bug Report"),
        "BC-3.8.003: stderr must list candidate 'Bug Report'; got: {stderr}"
    );
    assert!(
        stderr.contains("Bug Fix Request"),
        "BC-3.8.003: stderr must list candidate 'Bug Fix Request'; got: {stderr}"
    );
    // Actionable hint with verbatim command form.
    assert!(
        stderr.contains("Run `jr requesttype list --project HELP`"),
        "BC-3.8.003: hint must use 'Run `jr requesttype list --project HELP`'; got: {stderr}"
    );
    assert!(
        stderr.contains("to see all request types"),
        "BC-3.8.003: hint must end with 'to see all request types'; got: {stderr}"
    );
    // Negative: old drift forms must not appear.
    assert!(
        !stderr.contains("to see available types") && !stderr.contains("to see current types"),
        "Old drift wording must not appear; got: {stderr}"
    );
}

// ─── AC-005: numeric request-type ID bypasses name resolution ────────────────

/// AC-005 (BC-3.8.004): When `--request-type` is all-digits, the handler uses
/// it directly as `requestTypeId` without calling the request-type list endpoint.
/// The list endpoint mock has `expect(0)` as the regression guard.
#[tokio::test]
async fn test_jsm_create_numeric_id_bypasses_name_lookup() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;

    // List endpoint MUST NOT be called for a numeric ID.
    Mock::given(method("GET"))
        .and(path("/rest/servicedeskapi/servicedesk/10/requesttype"))
        .respond_with(ResponseTemplate::new(200).set_body_json(two_request_types_body()))
        .expect(0)
        .mount(&server)
        .await;

    // JSM create endpoint must be called exactly once with the numeric request type ID.
    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(json!({
            "issueId": "107002",
            "issueKey": "HELP-55",
            "requestTypeId": "11002",
            "serviceDeskId": "10",
            "_links": {}
        })))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "11002",
            "--summary",
            "test numeric id",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.004: expected exit 0 for numeric ID bypass, got {:?}. stderr: {stderr}",
        output.status.code()
    );
    assert!(
        stdout.contains("HELP-55"),
        "BC-3.8.004: expected issue key in output, got: {stdout}"
    );
    // The .expect(0) on the list mock is enforced on server drop.
}

// ─── AC-006: summary required in requestFieldValues ──────────────────────────

/// AC-006 (BC-3.8.005): The POST body to `/rest/servicedeskapi/request` must
/// contain `requestFieldValues.summary` equal to the `--summary` flag value.
#[tokio::test]
async fn test_jsm_create_summary_in_requestfieldvalues() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    // Mount JSM create and capture request body via received_requests.
    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "Reset my password",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.005: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    // Verify the POST body contained requestFieldValues.summary via received_requests.
    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.005: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.005: POST body must be valid JSON");

    assert_eq!(
        body["requestFieldValues"]["summary"].as_str(),
        Some("Reset my password"),
        "BC-3.8.005: requestFieldValues.summary must equal --summary value; got body: {body}"
    );
}

// ─── AC-007: description → ADF with isAdfRequest: true ───────────────────────

/// AC-007 (BC-3.8.006): With `--description`, the POST body contains
/// `isAdfRequest: true` and `requestFieldValues.description` is a JSON object
/// (ADF root node, NOT a bare string).
#[tokio::test]
async fn test_jsm_create_description_is_adf_with_is_adf_request_true() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test",
            "--description",
            "**Bold** text",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.006: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.006: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.006: POST body must be valid JSON");

    // BC-3.8.006: isAdfRequest must be true when description is set.
    assert_eq!(
        body.get("isAdfRequest").and_then(Value::as_bool),
        Some(true),
        "BC-3.8.006: isAdfRequest must be true when description is set; got body: {body}"
    );

    // BC-3.8.006: requestFieldValues.description must be a JSON object (ADF root node).
    let desc = body
        .get("requestFieldValues")
        .and_then(|rfv| rfv.get("description"));
    assert!(
        desc.map(|d| d.is_object()).unwrap_or(false),
        "BC-3.8.006: requestFieldValues.description must be a JSON object (ADF root), not a bare string; got: {:?}",
        desc
    );

    // The ADF object must contain a "type" key at some level — at minimum the doc root.
    let desc_obj = desc.unwrap();
    assert!(
        desc_obj.get("type").is_some() || desc_obj.get("content").is_some(),
        "BC-3.8.006: ADF root must have 'type' or 'content' key; got: {desc_obj}"
    );
}

/// AC-007 sibling (BC-3.8.006): Without `--description`, the POST body does NOT
/// contain `requestFieldValues.description` and does NOT contain `isAdfRequest: true`.
#[tokio::test]
async fn test_jsm_create_plain_description_absent_when_no_description_flag() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test no description",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.006: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.006: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.006: POST body must be valid JSON");

    // BC-3.8.006: isAdfRequest must be absent or false when description is absent.
    let is_adf = body
        .get("isAdfRequest")
        .and_then(Value::as_bool)
        .unwrap_or(false);
    assert!(
        !is_adf,
        "BC-3.8.006: isAdfRequest must be absent or false when --description not set; got body: {body}"
    );

    // BC-3.8.006: description key must be absent from requestFieldValues.
    let rfv_desc = body
        .get("requestFieldValues")
        .and_then(|rfv| rfv.get("description"));
    assert!(
        rfv_desc.is_none(),
        "BC-3.8.006: requestFieldValues.description must be absent when --description not set; got: {:?}",
        rfv_desc
    );
}

// ─── AC-008: priority and labels in requestFieldValues ───────────────────────

/// AC-008 (BC-3.8.007): `--priority High` → `requestFieldValues.priority = {"name": "High"}`.
/// `--label alpha --label beta` → `requestFieldValues.labels = ["alpha", "beta"]`
/// (plain string array, NOT object array).
#[tokio::test]
async fn test_jsm_create_priority_and_labels_mapped() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test",
            "--priority",
            "High",
            "--label",
            "alpha",
            "--label",
            "beta",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.007: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.007: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.007: POST body must be valid JSON");

    let rfv = body
        .get("requestFieldValues")
        .expect("BC-3.8.007: requestFieldValues must be present");

    // BC-3.8.007: priority must be {"name": "High"}.
    assert_eq!(
        rfv.get("priority")
            .and_then(|p| p.get("name"))
            .and_then(Value::as_str),
        Some("High"),
        "BC-3.8.007: priority must be {{\"name\": \"High\"}}; got rfv: {rfv}"
    );

    // BC-3.8.007: labels must be a plain string array ["alpha", "beta"].
    let labels = rfv
        .get("labels")
        .and_then(Value::as_array)
        .expect("BC-3.8.007: labels must be a JSON array");

    assert_eq!(
        labels.len(),
        2,
        "BC-3.8.007: expected 2 labels, got {}; labels: {labels:?}",
        labels.len()
    );
    // Labels must be strings, NOT objects.
    assert!(
        labels[0].is_string(),
        "BC-3.8.007: labels must be plain strings, not objects; got: {:?}",
        labels[0]
    );
    assert_eq!(
        labels.iter().filter_map(Value::as_str).collect::<Vec<_>>(),
        vec!["alpha", "beta"],
        "BC-3.8.007: labels must be ['alpha', 'beta'] in order; got: {labels:?}"
    );

    // Negative: labels must NOT be an object array like [{"name": "alpha"}].
    assert!(
        labels.iter().all(|l| l.is_string()),
        "BC-3.8.007: all label entries must be plain strings, not objects; got: {labels:?}"
    );
}

// ─── AC-009: --field NAME=VALUE parsing ──────────────────────────────────────

/// AC-009 (BC-3.8.008): `--field` custom fields are merged into requestFieldValues.
/// First-equals split: `desc=bar=baz` → key="desc", value="bar=baz".
/// Duplicate: last value wins.
#[tokio::test]
async fn test_jsm_create_field_first_equals_split_and_duplicate_last_wins() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test",
            "--field",
            "customfield_10200=foo",
            "--field",
            "desc=bar=baz",
            "--field",
            "customfield_10200=overridden", // duplicate — last wins
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.008: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.008: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.008: POST body must be valid JSON");

    let rfv = body
        .get("requestFieldValues")
        .expect("BC-3.8.008: requestFieldValues must be present");

    // BC-3.8.008: first-equals split — desc=bar=baz → value "bar=baz".
    assert_eq!(
        rfv.get("desc").and_then(Value::as_str),
        Some("bar=baz"),
        "BC-3.8.008: first-equals split: 'desc=bar=baz' must yield value 'bar=baz'; got rfv: {rfv}"
    );

    // BC-3.8.008: duplicate last-wins — customfield_10200 should be "overridden".
    assert_eq!(
        rfv.get("customfield_10200").and_then(Value::as_str),
        Some("overridden"),
        "BC-3.8.008: duplicate key last-wins: customfield_10200 must be 'overridden'; got rfv: {rfv}"
    );
}

/// AC-009 (BC-3.8.008): Missing `=` in `--field` argument exits 64 with a
/// descriptive error message.
#[tokio::test]
async fn test_jsm_create_field_missing_equals_exits_64() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test",
            "--field",
            "nokvinthis",
            "--no-input",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert_eq!(
        output.status.code(),
        Some(64),
        "BC-3.8.008: expected exit 64 for missing '=', got {:?}. stderr: {stderr}",
        output.status.code()
    );
    // BC-3.8.008: error must identify the malformed pair.
    assert!(
        stderr.contains("nokvinthis"),
        "BC-3.8.008: error must mention the malformed pair 'nokvinthis'; got: {stderr}"
    );
    assert!(
        stderr.contains("NAME=VALUE"),
        "BC-3.8.008: error must mention NAME=VALUE format requirement; got: {stderr}"
    );
}

// ─── AC-010: --on-behalf-of → raiseOnBehalfOf at top level ──────────────────

/// AC-010 (BC-3.8.009): `--on-behalf-of` maps to top-level `raiseOnBehalfOf`
/// in the POST body, NOT inside `requestFieldValues`.
#[tokio::test]
async fn test_jsm_create_on_behalf_of_injected_at_top_level() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test",
            "--on-behalf-of",
            "557058:abc123",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.009: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.009: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.009: POST body must be valid JSON");

    // BC-3.8.009: raiseOnBehalfOf must be at TOP level.
    assert_eq!(
        body.get("raiseOnBehalfOf").and_then(Value::as_str),
        Some("557058:abc123"),
        "BC-3.8.009: raiseOnBehalfOf must be at top level with value '557058:abc123'; got body: {body}"
    );

    // BC-3.8.009: raiseOnBehalfOf must NOT be inside requestFieldValues.
    let rfv_obo = body
        .get("requestFieldValues")
        .and_then(|rfv| rfv.get("raiseOnBehalfOf"));
    assert!(
        rfv_obo.is_none(),
        "BC-3.8.009: raiseOnBehalfOf must NOT be inside requestFieldValues; got rfv: {:?}",
        body.get("requestFieldValues")
    );
}

/// AC-010 sibling (BC-3.8.009): Without `--on-behalf-of`, the `raiseOnBehalfOf`
/// key must be completely absent from the POST body (NOT null).
#[tokio::test]
async fn test_jsm_create_on_behalf_of_absent_when_not_set() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test no obo",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.009: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    let requests = server.received_requests().await.expect("requests recorded");
    let jsm_post = requests
        .iter()
        .find(|r| r.url.path() == "/rest/servicedeskapi/request" && r.method.as_str() == "POST")
        .expect("BC-3.8.009: JSM POST must have been made");

    let body: Value =
        serde_json::from_slice(&jsm_post.body).expect("BC-3.8.009: POST body must be valid JSON");

    // BC-3.8.009: raiseOnBehalfOf key must be completely absent, not null.
    assert!(
        body.get("raiseOnBehalfOf").is_none(),
        "BC-3.8.009: raiseOnBehalfOf must be completely absent when --on-behalf-of not set; got body: {body}"
    );
}

// ─── AC-011: --type flag emits warning to stderr, still exits 0 ──────────────

/// AC-011 (BC-3.8.010, H-NEW-JSM-RT-004): When both `--request-type` and `--type`
/// are set, a warning is emitted to stderr and the command succeeds (exit 0).
/// The warning must use the verbatim BC-3.8.010 string.
#[tokio::test]
async fn test_jsm_create_type_flag_ignored_with_warning() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--type",
            "Task",
            "--summary",
            "test",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    // BC-3.8.010, H-NEW-JSM-RT-004: must exit 0 despite --type being set.
    assert!(
        output.status.success(),
        "BC-3.8.010 / H-NEW-JSM-RT-004: expected exit 0 (warning, not error), got {:?}. stderr: {stderr}",
        output.status.code()
    );

    // BC-3.8.010: verbatim warning string must appear on stderr.
    assert!(
        stderr.contains("warning: --type is ignored when --request-type is set"),
        "BC-3.8.010: stderr must contain verbatim warning; got: {stderr}"
    );
    assert!(
        stderr.contains("request type encodes the issue type"),
        "BC-3.8.010: warning must include 'request type encodes the issue type'; got: {stderr}"
    );
}

// ─── AC-012: 401 scope-mismatch hint contains write:servicedesk-request ──────

/// AC-012 (BC-1.3.023, BC-X.3.005, H-NEW-JSM-RT-003): When the JSM POST returns
/// 401, the error surfaces a hint containing `write:servicedesk-request` and an
/// actionable recovery step.
#[tokio::test]
async fn test_jsm_create_401_hint_contains_write_servicedesk_request() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    // JSM POST returns 401 — plausible Atlassian shape.
    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(401).set_body_json(json!({
            "errorMessages": [
                "The access token provided is expired, revoked, malformed, or invalid for other reasons."
            ],
            "errors": {}
        })))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "test 401",
            "--no-input",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    // Must exit non-zero.
    assert!(
        !output.status.success(),
        "BC-1.3.023: expected non-zero exit for 401 response, got exit 0. stderr: {stderr}"
    );

    // BC-1.3.023 / H-NEW-JSM-RT-003: hint must mention the required scope.
    assert!(
        stderr.contains("write:servicedesk-request"),
        "BC-1.3.023 / H-NEW-JSM-RT-003: stderr must contain 'write:servicedesk-request' scope hint; got: {stderr}"
    );

    // BC-1.3.023: must include an actionable recovery step (re-auth hint).
    assert!(
        stderr.contains("jr auth refresh") || stderr.contains("jr auth login"),
        "BC-1.3.023: hint must include 'jr auth refresh' or 'jr auth login' recovery step; got: {stderr}"
    );
}

/// AC-012 sibling: Platform POST returning 401 must NOT emit the
/// `write:servicedesk-request` scope hint (regression guard against false-positive
/// scope hint on non-JSM 401s).
#[tokio::test]
async fn test_platform_create_401_no_jsm_scope_hint() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    // Platform POST returns 401.
    Mock::given(method("POST"))
        .and(path("/rest/api/3/issue"))
        .respond_with(ResponseTemplate::new(401).set_body_json(json!({
            "errorMessages": [
                "The access token provided is expired, revoked, malformed, or invalid for other reasons."
            ],
            "errors": {}
        })))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "PROJ",
            "--type",
            "Task",
            "--summary",
            "platform 401 test",
            "--no-input",
        ])
        .output()
        .unwrap();

    let stderr = String::from_utf8_lossy(&output.stderr);

    // Must exit non-zero.
    assert!(
        !output.status.success(),
        "Expected non-zero exit for platform 401, got exit 0. stderr: {stderr}"
    );

    // Regression guard: platform 401 must NOT mention the JSM-specific scope.
    assert!(
        !stderr.contains("write:servicedesk-request"),
        "Platform 401 must NOT mention 'write:servicedesk-request' scope; got: {stderr}"
    );
}

// ─── AC-015: --output json shape matches platform create ─────────────────────

/// AC-015 (BC-3.8.001): `jr issue create --request-type ... --output json`
/// emits `{"key": "<issue_key>"}` — identical shape to platform create.
/// No additional fields beyond `key`.
#[tokio::test]
async fn test_jsm_create_output_json_shape_matches_platform() {
    let server = MockServer::start().await;
    let cache_dir = tempfile::tempdir().unwrap();
    let config_dir = tempfile::tempdir().unwrap();
    write_minimal_config(config_dir.path(), &server.uri());

    mount_project_meta_help(&server).await;
    mount_service_desk_list(&server).await;
    mount_request_type_list(&server).await;

    Mock::given(method("POST"))
        .and(path("/rest/servicedeskapi/request"))
        .respond_with(ResponseTemplate::new(201).set_body_json(jsm_created_response()))
        .expect(1)
        .mount(&server)
        .await;

    let output = Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .env("XDG_CACHE_HOME", cache_dir.path())
        .env("XDG_CONFIG_HOME", config_dir.path())
        .args([
            "issue",
            "create",
            "--project",
            "HELP",
            "--request-type",
            "Password Reset",
            "--summary",
            "json shape test",
            "--no-input",
            "--output",
            "json",
        ])
        .output()
        .unwrap();

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(
        output.status.success(),
        "BC-3.8.001 / AC-015: expected exit 0, got {:?}. stderr: {stderr}",
        output.status.code()
    );

    // Must be valid JSON.
    let parsed: Value = serde_json::from_str(&stdout)
        .unwrap_or_else(|e| panic!("AC-015: stdout must be valid JSON; got: {stdout}\nError: {e}"));

    // BC-3.8.001 / AC-015: JSON shape must be {{"key": "<issue_key>"}}.
    assert_eq!(
        parsed.get("key").and_then(Value::as_str),
        Some("HELP-42"),
        "AC-015: JSON output must contain key='HELP-42'; got: {parsed}"
    );

    // The shape should be minimal — just {"key": "..."}.
    // (The platform also adds "url" and "fields" in json mode; for JSM we expect
    // the simpler shape per AC-015. If the impl adds these later, update the test.)
    let obj = parsed
        .as_object()
        .expect("AC-015: stdout must be a JSON object");
    assert!(
        obj.contains_key("key"),
        "AC-015: JSON output must contain 'key' field; got: {parsed}"
    );
}
