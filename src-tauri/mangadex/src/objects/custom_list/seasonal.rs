use mangadex_api::MangaDexClient;
use mangadex_api::Result;
use mangadex_api_schema_rust::v5::CustomListData;
use serde::de::IntoDeserializer;
use serde::{Deserialize, Serialize};
use tauri::AppHandle;
use tauri::Runtime;
use uuid::Uuid;

use crate::utils::traits_utils::MangadexTauriManagerExt;

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct SeasonalData {
    pub id: Uuid,
}

#[cfg_attr(feature = "hotpath", hotpath::measure_all)]
impl SeasonalData {
    pub async fn get<R>(app: &AppHandle<R>) -> crate::Result<Self>
    where
        R: Runtime,
    {
        let config = crate::plugin_setup::plugin_config::PluginConfig::deserialize(
            app.config()
                .plugins
                .0
                .get("mangadex-desktop-api")
                .ok_or(crate::Error::PluginConfigNotFound)?
                .into_deserializer(),
        )?;
        Ok(app
            .get_mangadex_client()?
            .get_reqwest_client()
            .await
            .get(
                config
                    .seasonal_json_url
                    .ok_or(crate::Error::SeasonalJsonUrlNotFound)?,
            )
            .send()
            .await?
            .json()
            .await?)
    }
    pub async fn get_result(&self, client: &MangaDexClient) -> Result<CustomListData> {
        client.custom_list().id(self.id).get().send().await
    }
}
