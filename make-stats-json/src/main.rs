use std::path::PathBuf;

use structopt::StructOpt;

#[derive(Debug, StructOpt)]
struct Cli {
    /// The source statting db file (SQLite3 format).
    db_file: PathBuf,
}

fn main() {
    let cli = Cli::from_args();

    println!("{:?}", cli);
}
