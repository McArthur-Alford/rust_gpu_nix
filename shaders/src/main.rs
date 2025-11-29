use spirv_builder::{MetadataPrintout, SpirvBuilder};
use std::env;
use std::error::Error;
use std::fs;
use std::path::Path;

fn build_shader(path_to_crate: &str, codegen_names: bool) -> Result<(), Box<dyn Error>> {
    let manifest_dir = std::env::var("CARGO_MANIFEST_DIR").expect("Expected Manifest Dir");
    let builder_dir = &Path::new(&manifest_dir);
    let path_to_crate = builder_dir.join(path_to_crate);

    let result = SpirvBuilder::new(path_to_crate, "spirv-unknown-vulkan1.2")
        .print_metadata(MetadataPrintout::Full)
        .build()?;

    println!("{:?}", result.codegen_entry_point_strings());
    println!("{:?}", result.module);

    // if codegen_names {
    //     let out_dir = env::var_os("OUT_DIR").unwrap();
    //     let dest_path = Path::new(&out_dir).join("entry_points.rs");
    //     fs::create_dir_all(&out_dir).unwrap();
    //     fs::write(dest_path, result.codegen_entry_point_strings()).unwrap();
    // }
    Ok(())
}

fn main() -> Result<(), Box<dyn Error>> {
    build_shader("../crates/simplest-shader", true)?;
    Ok(())
}
