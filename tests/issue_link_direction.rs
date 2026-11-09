//! `jr issue link KEY1 KEY2 --type T` reads "KEY1 <outward verb of T> KEY2".
//!
//! Jira stores a link as a pair, and each issue then reads the link from its
//! own side: the issue that lists `outwardIssue: X` in its `issuelinks` reads
//! "<this> <outward verb> X". POST /rest/api/3/issueLink therefore takes the
//! subject of the outward verb (KEY1) as `inwardIssue` and the object (KEY2) as
//! `outwardIssue`. These tests pin the request body against a mock server for
//! each link type in the fixture, so the verb direction follows the type's own
//! inward and outward names and no live Jira is involved.
#[allow(dead_code)]
mod common;

use wiremock::matchers::{method, path};
use wiremock::{Mock, MockServer, ResponseTemplate};

async fn posted_link_body(link_type: &str) -> serde_json::Value {
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issueLinkType"))
        .respond_with(
            ResponseTemplate::new(200).set_body_json(common::fixtures::link_types_response()),
        )
        .mount(&server)
        .await;
    Mock::given(method("POST"))
        .and(path("/rest/api/3/issueLink"))
        .respond_with(ResponseTemplate::new(201))
        .expect(1)
        .mount(&server)
        .await;

    let output = assert_cmd::Command::cargo_bin("jr")
        .unwrap()
        .env("JR_BASE_URL", server.uri())
        .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
        .args([
            "--no-input",
            "issue",
            "link",
            "ABC-1",
            "ABC-2",
            "--type",
            link_type,
        ])
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "link failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let requests = server.received_requests().await.unwrap();
    let post = requests
        .iter()
        .find(|r| r.method.as_str() == "POST" && r.url.path() == "/rest/api/3/issueLink")
        .expect("no POST /rest/api/3/issueLink was sent");
    serde_json::from_slice(&post.body).unwrap()
}

#[tokio::test]
async fn link_key1_is_the_subject_of_the_outward_verb() {
    // (type, outward verb): "ABC-1 blocks ABC-2", "ABC-1 duplicates ABC-2",
    // "ABC-1 relates to ABC-2".
    for (link_type, _outward) in [
        ("Blocks", "blocks"),
        ("Duplicate", "duplicates"),
        ("Relates", "relates to"),
    ] {
        let body = posted_link_body(link_type).await;
        assert_eq!(body["type"]["name"], link_type, "type for {link_type}");
        assert_eq!(
            body["inwardIssue"]["key"], "ABC-1",
            "{link_type}: KEY1 must be inwardIssue, the issue that reads the outward verb: {body}"
        );
        assert_eq!(
            body["outwardIssue"]["key"], "ABC-2",
            "{link_type}: KEY2 must be outwardIssue, the object of the outward verb: {body}"
        );
    }
}
