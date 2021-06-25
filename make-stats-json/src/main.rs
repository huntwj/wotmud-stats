mod cli;
mod config;

use cli::Cli;
use config::Config;

fn main() {
    let cli = Cli::new();
    let config = Config::from(&cli);

    println!("Configuration options:\n{:?}", config);

    if cli.save {
        config.save();
    }
}
