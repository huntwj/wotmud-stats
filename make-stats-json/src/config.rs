use std::path::PathBuf;

use serde::{Deserialize, Serialize};

use crate::cli::Cli;

#[derive(Default, Debug, Serialize, Deserialize)]
pub struct Config {
    pub db_file: Option<PathBuf>,
}

impl Config {
    pub fn load() -> Self {
        confy::load("make-stats-json").expect("can open configuration file")
    }

    pub fn save(&self) {
        confy::store("make-stats-json", self).expect("can save configuration file");
    }
}

impl From<&Cli> for Config {
    fn from(cli: &Cli) -> Self {
        let mut config = Config::load();

        cli.db_file.as_ref().map(|db_file| {
            match &config.db_file {
                Some(config_db_file) if db_file == config_db_file => {
                    // Do nothing...
                }
                _ => config.db_file = Some(db_file.clone()),
            }
        });

        config
    }
}
