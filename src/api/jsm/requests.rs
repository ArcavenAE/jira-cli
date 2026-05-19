//! JSM request-submission API client methods.
//!
//! Effectful module (L4) — HTTP calls via `api::client`. No business logic.
//! The single method wraps `POST /rest/servicedeskapi/request`.
//!
//! `build_jsm_request_body` is a pure helper (no `JiraClient` dependency) for
//! constructing the POST body. It lives here so proptest properties (C.1–C.3)
//! can exercise it without a mock HTTP client.

use std::collections::HashMap;

use anyhow::Result;

use crate::api::client::JiraClient;
use crate::types::jsm::JsmRequestCreated;

impl JiraClient {
    /// Submit a new JSM customer request.
    ///
    /// POSTs `body` to `/rest/servicedeskapi/request` and deserializes the
    /// HTTP 201 response into [`JsmRequestCreated`].
    ///
    /// Traces: BC-3.8.001
    pub async fn create_jsm_request(&self, body: serde_json::Value) -> Result<JsmRequestCreated> {
        self.post_to_instance("/rest/servicedeskapi/request", &body)
            .await
    }
}

/// Build the POST body for `POST /rest/servicedeskapi/request`.
///
/// Pure helper — no HTTP calls, no `JiraClient` dependency. Assembles the
/// `requestFieldValues` map from caller-supplied fields and wraps it with
/// the top-level `serviceDeskId`, `requestTypeId`, and (when provided)
/// `raiseOnBehalfOf`.
///
/// # Body shape
///
/// ```json
/// {
///   "serviceDeskId": "<service_desk_id>",
///   "requestTypeId": "<request_type_id>",
///   "requestFieldValues": {
///     "summary": "<summary>",
///     // optional: "description": <ADF root object>,
///     // optional: "priority": {"name": "<priority>"},
///     // optional: "labels": ["<label>", ...],
///     // any extra fields from --field NAME=VALUE pairs
///   },
///   // optional (top-level, NOT in requestFieldValues):
///   "isAdfRequest": true,
///   "raiseOnBehalfOf": "<accountId>"
/// }
/// ```
///
/// Per BC-3.8.006: `isAdfRequest: true` is included if and only if
/// `description` is `Some`. Per BC-3.8.009: `raiseOnBehalfOf` is included
/// if and only if `on_behalf_of` is `Some` (the key is completely absent
/// otherwise — NOT null). Per BC-3.8.007: `labels` is a plain string array,
/// NOT an object array.
///
/// Traces: BC-3.8.001, BC-3.8.005, BC-3.8.006, BC-3.8.007, BC-3.8.008,
///         BC-3.8.009
///
/// # TODO(S-288-pr4 Step 4): implement body
#[allow(unused_variables)] // TODO(S-288-pr4 Step 4): remove after implementing
#[allow(clippy::too_many_arguments)] // TODO(S-288-pr4 Step 4): Step 4 implementer to consider a builder struct
pub fn build_jsm_request_body(
    service_desk_id: &str,
    request_type_id: &str,
    summary: &str,
    description: Option<&str>,
    markdown: bool,
    priority: Option<&str>,
    labels: &[String],
    on_behalf_of: Option<&str>,
    extra_fields: &HashMap<String, String>,
) -> serde_json::Value {
    todo!("S-288-pr4 Step 4")
}
