#[allow(dead_code)]
mod common;

use assert_cmd::Command;
use wiremock::matchers::{method, path, query_param};
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

fn board_response(id: u64, name: &str, board_type: &str, project_key: &str) -> serde_json::Value {
    serde_json::json!({
        "id": id,
        "name": name,
        "type": board_type,
        "location": {
            "projectKey": project_key,
            "projectName": format!("{} Project", project_key)
        }
    })
}

fn board_list_response(boards: Vec<serde_json::Value>) -> serde_json::Value {
    let total = boards.len() as u32;
    serde_json::json!({
        "values": boards,
        "startAt": 0,
        "maxResults": 50,
        "total": total
    })
}

// --- Board view --limit tests (from PR #73) ---

#[tokio::test]
async fn get_sprint_issues_with_limit() {
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

// --- Board auto-resolve tests (from #70) ---

#[tokio::test]
async fn list_boards_with_project_and_type_filter() {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/agile/1.0/board"))
        .and(query_param("projectKeyOrId", "PROJ"))
        .and(query_param("type", "scrum"))
        .respond_with(
            ResponseTemplate::new(200).set_body_json(board_list_response(vec![board_response(
                42, "My Board", "scrum", "PROJ",
            )])),
        )
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let boards = client
        .list_boards(Some("PROJ"), Some("scrum"))
        .await
        .unwrap();
    assert_eq!(boards.len(), 1);
    assert_eq!(boards[0].id, 42);
    assert_eq!(boards[0].name, "My Board");
}

#[tokio::test]
async fn list_boards_without_filters() {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/agile/1.0/board"))
        .respond_with(
            ResponseTemplate::new(200).set_body_json(board_list_response(vec![
                board_response(1, "Board A", "scrum", "FOO"),
                board_response(2, "Board B", "kanban", "BAR"),
            ])),
        )
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let boards = client.list_boards(None, None).await.unwrap();
    assert_eq!(boards.len(), 2);
}

#[tokio::test]
async fn list_boards_empty_result() {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/agile/1.0/board"))
        .and(query_param("projectKeyOrId", "NOPE"))
        .respond_with(ResponseTemplate::new(200).set_body_json(board_list_response(vec![])))
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let boards = client.list_boards(Some("NOPE"), None).await.unwrap();
    assert!(boards.is_empty());
}
