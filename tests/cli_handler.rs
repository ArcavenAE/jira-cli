#[allow(dead_code)]
mod common;

use assert_cmd::Command;
use predicates::prelude::*;
use wiremock::matchers::{body_partial_json, method, path, query_param};
use wiremock::{Mock, MockServer, ResponseTemplate};

/// Build a `jr` command pre-configured for handler-level testing.
///
/// Sets `JR_BASE_URL` and `JR_AUTH_HEADER` env vars so the binary
/// routes API calls to the mock server and bypasses keychain auth.
fn jr_cmd(server_uri: &str) -> Command {
    let mut cmd = Command::cargo_bin("jr").unwrap();
    cmd.env("JR_BASE_URL", server_uri)
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .arg("--no-input")
        .arg("--output")
        .arg("json");
    cmd
}

#[tokio::test(flavor = "multi_thread")]
async fn test_handler_assign_with_account_id() {
    let server = MockServer::start().await;

    // Mock GET issue — currently unassigned
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/HDL-1"))
        .respond_with(ResponseTemplate::new(200).set_body_json(
            common::fixtures::issue_response_with_assignee("HDL-1", "Handler test", None),
        ))
        .mount(&server)
        .await;

    // Mock PUT assignee
    Mock::given(method("PUT"))
        .and(path("/rest/api/3/issue/HDL-1/assignee"))
        .and(body_partial_json(serde_json::json!({
            "accountId": "direct-id-001"
        })))
        .respond_with(ResponseTemplate::new(204))
        .mount(&server)
        .await;

    jr_cmd(&server.uri())
        .args(["issue", "assign", "HDL-1", "--account-id", "direct-id-001"])
        .assert()
        .success()
        .stdout(predicate::str::contains("\"changed\": true"))
        .stdout(predicate::str::contains("\"key\": \"HDL-1\""));
}

#[tokio::test(flavor = "multi_thread")]
async fn test_handler_assign_with_to_name_search() {
    let server = MockServer::start().await;

    // Mock assignable user search for issue HDL-2
    Mock::given(method("GET"))
        .and(path("/rest/api/3/user/assignable/search"))
        .and(query_param("query", "Jane"))
        .and(query_param("issueKey", "HDL-2"))
        .respond_with(ResponseTemplate::new(200).set_body_json(
            common::fixtures::user_search_response(vec![("acc-jane-456", "Jane Doe", true)]),
        ))
        .mount(&server)
        .await;

    // Mock GET issue — currently unassigned
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/HDL-2"))
        .respond_with(ResponseTemplate::new(200).set_body_json(
            common::fixtures::issue_response_with_assignee("HDL-2", "Name search test", None),
        ))
        .mount(&server)
        .await;

    // Mock PUT assignee
    Mock::given(method("PUT"))
        .and(path("/rest/api/3/issue/HDL-2/assignee"))
        .and(body_partial_json(serde_json::json!({
            "accountId": "acc-jane-456"
        })))
        .respond_with(ResponseTemplate::new(204))
        .mount(&server)
        .await;

    jr_cmd(&server.uri())
        .args(["issue", "assign", "HDL-2", "--to", "Jane"])
        .assert()
        .success()
        .stdout(predicate::str::contains("\"assignee\": \"Jane Doe\""))
        .stdout(predicate::str::contains("\"changed\": true"));
}

#[tokio::test(flavor = "multi_thread")]
async fn test_handler_assign_self() {
    let server = MockServer::start().await;

    // Mock GET myself
    Mock::given(method("GET"))
        .and(path("/rest/api/3/myself"))
        .respond_with(ResponseTemplate::new(200).set_body_json(common::fixtures::user_response()))
        .mount(&server)
        .await;

    // Mock GET issue — currently unassigned
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/HDL-3"))
        .respond_with(ResponseTemplate::new(200).set_body_json(
            common::fixtures::issue_response_with_assignee("HDL-3", "Self-assign test", None),
        ))
        .mount(&server)
        .await;

    // Mock PUT assignee
    Mock::given(method("PUT"))
        .and(path("/rest/api/3/issue/HDL-3/assignee"))
        .and(body_partial_json(serde_json::json!({
            "accountId": "abc123"
        })))
        .respond_with(ResponseTemplate::new(204))
        .mount(&server)
        .await;

    jr_cmd(&server.uri())
        .args(["issue", "assign", "HDL-3"])
        .assert()
        .success()
        .stdout(predicate::str::contains("\"assignee\": \"Test User\""))
        .stdout(predicate::str::contains("\"changed\": true"));
}

#[tokio::test(flavor = "multi_thread")]
async fn test_handler_assign_unassign() {
    let server = MockServer::start().await;

    // Mock PUT assignee with null (unassign)
    Mock::given(method("PUT"))
        .and(path("/rest/api/3/issue/HDL-4/assignee"))
        .and(body_partial_json(serde_json::json!({
            "accountId": null
        })))
        .respond_with(ResponseTemplate::new(204))
        .mount(&server)
        .await;

    jr_cmd(&server.uri())
        .args(["issue", "assign", "HDL-4", "--unassign"])
        .assert()
        .success()
        .stdout(predicate::str::contains("\"assignee\": null"))
        .stdout(predicate::str::contains("\"changed\": true"));
}

#[tokio::test(flavor = "multi_thread")]
async fn test_handler_assign_idempotent() {
    let server = MockServer::start().await;

    // Mock GET issue — already assigned to the target account
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/HDL-5"))
        .respond_with(ResponseTemplate::new(200).set_body_json(
            common::fixtures::issue_response_with_assignee(
                "HDL-5",
                "Already assigned",
                Some(("direct-id-001", "direct-id-001")),
            ),
        ))
        .mount(&server)
        .await;

    // No PUT mock — should not be called

    jr_cmd(&server.uri())
        .args(["issue", "assign", "HDL-5", "--account-id", "direct-id-001"])
        .assert()
        .success()
        .stdout(predicate::str::contains("\"changed\": false"));
}
