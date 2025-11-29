fn main() {
    let status = std::process::Command::new("cargo")
        .args(&["xtask", "compile-shaders"])
        .status()
        .expect("Failed to compile shaders");

    if !status.success() {
        panic!("Failed to compile shaders");
    }
}
