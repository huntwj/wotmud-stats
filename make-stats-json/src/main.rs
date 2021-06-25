mod cli;
mod config;

use serde::Serialize;
use sqlx::sqlite::SqlitePoolOptions;

use cli::Cli;
use config::Config;

#[derive(Serialize)]
struct Homeland {
    id: i64,
    #[serde(rename = "name")]
    homeland: String,
}

#[derive(Serialize)]
struct Class {
    id: i64,
    #[serde(rename = "name")]
    class: String,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
struct StattedChar {
    id: i64,
    class_id: i64,
    homeland_id: i64,
    str: i64,
    int: i64,
    wil: i64,
    dex: i64,
    con: i64,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct DataFile {
    homelands: Vec<Homeland>,
    classes: Vec<Class>,
    statted_chars: Vec<StattedChar>,
}

#[tokio::main]
async fn main() -> Result<(), sqlx::Error> {
    let cli = Cli::new();
    let config = Config::from(&cli);

    // println!("Configuration options:\n{:?}", config);

    if cli.save {
        config.save();
    }

    match config.db_file {
        Some(db_file) => match db_file.to_str() {
            Some(file) => {
                let pool = SqlitePoolOptions::new()
                    .max_connections(3)
                    .connect(file)
                    .await?;

                let homelands_query =
                    sqlx::query_as!(Homeland, "SELECT [id], [homeland] FROM [homelands]")
                        .fetch_all(&pool);

                let classes_query =
                    sqlx::query_as!(Class, "SELECT [id], [class] FROM [classes]").fetch_all(&pool);

                let statted_chars_query = sqlx::query_as!(StattedChar, "
                    SELECT 
                        [s].[id], [t].[homelandId] as homeland_id, [t].[classId] as class_id, str, int, wil, dex, con 
                    FROM [stats] as [s]
                    JOIN [toons] as [t] ON [s].[toonId] = [t].[id]
                    ").fetch_all(&pool);

                let (homelands, classes, statted_chars) =
                    tokio::try_join!(homelands_query, classes_query, statted_chars_query)?;

                let data_file = DataFile {
                    homelands,
                    classes,
                    statted_chars,
                };

                match serde_json::to_string_pretty(&data_file) {
                    Ok(s) => println!("{}", s),
                    Err(e) => println!("Error: {:?}", e),
                }
            }
            None => {
                println!("Invalid database path specifed.");
            }
        },
        None => {
            println!("Please specify a database via command line or config file.")
        }
    }

    Ok(())
}
