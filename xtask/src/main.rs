use clap::{Parser, Subcommand};

#[derive(Subcommand)]
enum Command {
    CompileShaders,
}

#[derive(Parser)]
#[clap(author, version, about)]
struct Cli {
    #[clap(subcommand)]
    subcommand: Command,
}

#[tokio::main]
async fn main() {
    env_logger::builder().init();
    log::info!("running xtask");

    let cli = Cli::parse();
    match cli.subcommand {
        Command::CompileShaders => {
            // let paths = ["shaders"]
            // log::info!("Calling `cargo gpu {}`", paths)
        }
    }
}
