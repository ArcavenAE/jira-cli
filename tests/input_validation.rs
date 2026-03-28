#[allow(dead_code)]
mod common;

use wiremock::matchers::{method, path};
use wiremock::{Mock, MockServer, ResponseTemplate};

#[tokio::test]
async fn project_exists_returns_true_for_valid_project() {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/api/3/project/PROJ"))
        .respond_with(ResponseTemplate::new(200).set_body_json(serde_json::json!({
            "id": "10000",
            "key": "PROJ",
            "name": "My Project"
        })))
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    assert!(client.project_exists("PROJ").await.unwrap());
}

#[tokio::test]
async fn project_exists_returns_false_for_invalid_project() {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/api/3/project/NOPE"))
        .respond_with(ResponseTemplate::new(404).set_body_json(serde_json::json!({
            "errorMessages": ["No project could be found with key 'NOPE'."],
            "errors": {}
        })))
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    assert!(!client.project_exists("NOPE").await.unwrap());
}

#[tokio::test]
async fn get_all_statuses_returns_status_names() {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/api/3/status"))
        .respond_with(ResponseTemplate::new(200).set_body_json(serde_json::json!([
            {"id": "1", "name": "To Do", "statusCategory": {"key": "new"}},
            {"id": "2", "name": "In Progress", "statusCategory": {"key": "indeterminate"}},
            {"id": "3", "name": "Done", "statusCategory": {"key": "done"}}
        ])))
        .mount(&server)
        .await;

    let client =
        jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let statuses = client.get_all_statuses().await.unwrap();
    assert_eq!(statuses.len(), 3);
    assert!(statuses.contains(&"To Do".to_string()));
    assert!(statuses.contains(&"In Progress".to_string()));
    assert!(statuses.contains(&"Done".to_string()));
}
