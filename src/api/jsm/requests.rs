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

/// Proptest properties for `build_jsm_request_body` (AC-014, BC-3.8.001..009).
///
/// Properties C.1–C.3 cover the three invariants from the verification delta.
///
/// RED GATE: All three properties FAIL (with `todo!()` panic) until Step 4
/// implements `build_jsm_request_body`.
#[cfg(test)]
mod proptests {
    use super::build_jsm_request_body;
    use proptest::prelude::*;

    proptest! {
        /// C.1 (BC-3.8.005): `summary` is always present in `requestFieldValues`
        /// and equals the passed-in `summary` argument.
        ///
        /// RED GATE: FAILS with todo!() until Step 4.
        #[test]
        fn prop_build_jsm_request_body_summary_always_present(
            service_desk_id in "[0-9]{1,5}",
            request_type_id in "[0-9]{1,5}",
            summary in ".{1,100}",
        ) {
            let extra = std::collections::HashMap::new();
            let body = build_jsm_request_body(
                &service_desk_id,
                &request_type_id,
                &summary,
                None,
                false,
                None,
                &[],
                None,
                &extra,
            );
            let rfv_summary = body
                .get("requestFieldValues")
                .and_then(|rfv| rfv.get("summary"))
                .and_then(serde_json::Value::as_str);
            prop_assert_eq!(
                rfv_summary,
                Some(summary.as_str()),
                "C.1: BC-3.8.005 summary must always appear in requestFieldValues"
            );
        }

        /// C.2 (BC-3.8.006): When `description` is `Some`, the body must include
        /// `isAdfRequest: true` AND `requestFieldValues.description` must be a
        /// JSON object (ADF root). When `description` is `None`, both must be absent.
        ///
        /// RED GATE: FAILS with todo!() until Step 4.
        #[test]
        fn prop_build_jsm_request_body_description_adf_presence(
            service_desk_id in "[0-9]{1,5}",
            request_type_id in "[0-9]{1,5}",
            summary in "[a-z ]{1,40}",
            desc in "[a-z ]{1,40}",
            has_desc in any::<bool>(),
        ) {
            let extra = std::collections::HashMap::new();
            let description = if has_desc { Some(desc.as_str()) } else { None };
            let body = build_jsm_request_body(
                &service_desk_id,
                &request_type_id,
                &summary,
                description,
                false,
                None,
                &[],
                None,
                &extra,
            );
            if has_desc {
                prop_assert_eq!(
                    body.get("isAdfRequest").and_then(serde_json::Value::as_bool),
                    Some(true),
                    "C.2: BC-3.8.006 isAdfRequest must be true when description is Some"
                );
                let desc_val = body.get("requestFieldValues").and_then(|rfv| rfv.get("description"));
                prop_assert!(
                    desc_val.map(|d| d.is_object()).unwrap_or(false),
                    "C.2: BC-3.8.006 description must be ADF object when Some; got: {:?}",
                    desc_val
                );
            } else {
                let is_adf = body.get("isAdfRequest").and_then(serde_json::Value::as_bool).unwrap_or(false);
                prop_assert!(
                    !is_adf,
                    "C.2: BC-3.8.006 isAdfRequest must be absent/false when description is None"
                );
                let rfv_desc = body.get("requestFieldValues").and_then(|rfv| rfv.get("description"));
                prop_assert!(
                    rfv_desc.is_none(),
                    "C.2: BC-3.8.006 requestFieldValues.description must be absent when None; got: {:?}",
                    rfv_desc
                );
            }
        }

        /// C.3 (BC-3.8.009): When `on_behalf_of` is `Some`, `raiseOnBehalfOf` is
        /// present at the top level of the body. When `None`, the key is completely
        /// absent (NOT null).
        ///
        /// RED GATE: FAILS with todo!() until Step 4.
        #[test]
        fn prop_build_jsm_request_body_raise_on_behalf_of_presence(
            service_desk_id in "[0-9]{1,5}",
            request_type_id in "[0-9]{1,5}",
            summary in "[a-z ]{1,40}",
            account_id in "[a-z0-9:]{1,30}",
            has_obo in any::<bool>(),
        ) {
            let extra = std::collections::HashMap::new();
            let on_behalf_of = if has_obo { Some(account_id.as_str()) } else { None };
            let body = build_jsm_request_body(
                &service_desk_id,
                &request_type_id,
                &summary,
                None,
                false,
                None,
                &[],
                on_behalf_of,
                &extra,
            );
            if has_obo {
                prop_assert_eq!(
                    body.get("raiseOnBehalfOf").and_then(serde_json::Value::as_str),
                    Some(account_id.as_str()),
                    "C.3: BC-3.8.009 raiseOnBehalfOf must equal accountId when Some"
                );
            } else {
                prop_assert!(
                    body.get("raiseOnBehalfOf").is_none(),
                    "C.3: BC-3.8.009 raiseOnBehalfOf must be completely absent when None; got body: {body:?}"
                );
            }
        }
    }
}
