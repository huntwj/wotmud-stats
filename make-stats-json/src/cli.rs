use std::path::PathBuf;
use structopt::StructOpt;

#[derive(Debug, StructOpt)]
pub struct Cli {
    /// The source statting db file (SQLite3 format).
    pub db_file: Option<PathBuf>,

    /// Save the command line options for use in future invocations
    #[structopt(short, long)]
    pub save: bool,
}

impl Cli {
    pub fn new() -> Self {
        Cli::from_args()
    }
}
