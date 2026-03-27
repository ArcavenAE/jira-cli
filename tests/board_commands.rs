#[allow(dead_code)]
mod common;

use assert_cmd::Command;
use wiremock::matchers::{method, path};
use wiremock::{Mock, MockServer, ResponseTemplate};

/// Helper: build N issues for testing.
fn make_issues(count: usize) -> Vec<serde_json::Value> {
    (1..=count)
        .map(|i| {
            common::fixtures::issue_response(
                &format!("TEST-{}", i),
                &format!("Issue {}", i),
                "In Progress",
            )
        })
        .collect()
}

#[tokio::test]
async fn get_sprint_issues_with_limit() {
    let server = MockServer::start().await;

    // Mock sprint issues — return 5 issues with total=5
    Mock::given(method("GET"))
        .and(path("/rest/agile/1.0/sprint/100/issue"))
        .respond_with(
            ResponseTemplate::new(200)
                .set_body_json(common::fixtures::sprint_issues_response(make_issues(5), 5)),
        )
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".into());
    let result = client
        .get_sprint_issues(100, None, Some(3), &[])
        .await
        .unwrap();

    assert_eq!(result.issues.len(), 3);
    assert!(result.has_more);
    assert_eq!(result.issues[0].key, "TEST-1");
    assert_eq!(result.issues[2].key, "TEST-3");
}

#[tokio::test]
async fn get_sprint_issues_no_limit() {
    let server = MockServer::start().await;

    Mock::given(method("GET"))
        .and(path("/rest/agile/1.0/sprint/100/issue"))
        .respond_with(
            ResponseTemplate::new(200)
                .set_body_json(common::fixtures::sprint_issues_response(make_issues(5), 5)),
        )
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".into());
    let result = client
        .get_sprint_issues(100, None, None, &[])
        .await
        .unwrap();

    assert_eq!(result.issues.len(), 5);
    assert!(!result.has_more);
}

#[tokio::test]
async fn search_issues_with_limit() {
    let server = MockServer::start().await;

    // Return 5 issues with a next page token (indicating more exist)
    Mock::given(method("POST"))
        .and(path("/rest/api/3/search/jql"))
        .respond_with(ResponseTemplate::new(200).set_body_json(
            common::fixtures::issue_search_response_with_next_page(make_issues(5)),
        ))
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".into());
    let result = client
        .search_issues("statusCategory != Done ORDER BY rank ASC", Some(3), &[])
        .await
        .unwrap();

    assert_eq!(result.issues.len(), 3);
    assert!(result.has_more);
}

#[test]
fn board_view_limit_and_all_conflict() {
    let mut cmd = Command::cargo_bin("jr").unwrap();
    cmd.arg("board")
        .arg("view")
        .arg("--limit")
        .arg("3")
        .arg("--all");

    cmd.assert().failure().code(2);
}
