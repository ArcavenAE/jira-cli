use anyhow::Result;
use serde::Deserialize;

use crate::api::client::JiraClient;
use crate::cache;
use crate::error::JrError;

#[derive(Deserialize)]
struct WorkspaceResponse {
    #[serde(rename = "workspaceId")]
    workspace_id: String,
}

/// Get the Assets workspace ID, using cache when available.
pub async fn get_or_fetch_workspace_id(client: &JiraClient) -> Result<String> {
    if let Some(cached) = cache::read_workspace_cache()? {
        return Ok(cached.workspace_id);
    }

    let resp: WorkspaceResponse = client
        .get_from_instance("/rest/servicedeskapi/assets/workspace")
        .await
        .map_err(|e| {
            let msg = e.to_string();
            if msg.contains("404") || msg.contains("403") {
                JrError::UserError(
                    "Assets is not available on this Jira site. \
                     Assets requires Jira Service Management Premium or Enterprise."
                        .into(),
                )
                .into()
            } else {
                e
            }
        })?;

    let _ = cache::write_workspace_cache(&resp.workspace_id);

    Ok(resp.workspace_id)
}
