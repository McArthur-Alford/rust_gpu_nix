{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ (import rust-overlay) ];
        };

        craneLib = crane.mkLib pkgs;
        craneLibGPU = craneLib.overrideToolchain (
          p:
          p.rust-bin.fromRustcRev {
            rev = "1a5f8bce74ee432f7cc3aa131bc3d6920e06de10";
            components = {
              # rustc = "";
              # rust-src = "";
            };
          }
        );

        my-crate = craneLib.buildPackage {
          src = craneLib.cleanCargoSource ./.;

          buildInputs = [ ];
        };

        runtimeDeps = (
          with pkgs;
          [
            pkg-config
            libxkbcommon
            alsa-lib
            udev
            wayland
          ]
          ++ (with xorg; [
            libXcursor
            libXrandr
            libXi
            libX11
          ])
        );
      in
      {
        packages.default = my-crate;
        # devShells.default = craneLib.devShell {
        #   RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
        #   LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath runtimeDeps}";
        #   NIGHTLY = "${craneLibGPU}";

        #   packages =
        #     with pkgs;
        #     [
        #       rustfmt
        #       rust-analyzer
        #       rustPackages.clippy
        #       rustup
        #       cargo-flamegraph
        #       just
        #       spirv-tools
        #     ]
        #     ++ runtimeDeps;
        # };
      }
    );
}

# # {
# #   inputs = {
# #     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
# #     rust-overlay.url = "github:oxalica/rust-overlay";
# #   };

# #   outputs =
# #     {
# #       self,
# #       nixpkgs,
# #       rust-overlay,
# #     }:
# #     let
# #       system = "x86_64-linux";
# #       pkgs = import nixpkgs {
# #         inherit system;
# #         overlays = [ rust-overlay.overlays.default ];
# #       };
# #       # toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
# #       toolchain = pkgs.rust-bin.fromRustcRev {
# #         rev = "1a5f8bce74ee432f7cc3aa131bc3d6920e06de10";
# #         components = {
# #           # rustc = "";
# #           # rust-src = "";
# #         };
# #       };
# #     in
# #     {
# #       devShells.${system}.default = pkgs.mkShell {
# #         packages = [
# #           toolchain
# #         ];
# #       };
# #     };
# # }

# {
#   description = "A devShell example";

#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     rust-overlay.url = "github:oxalica/rust-overlay";
#     flake-utils.url = "github:numtide/flake-utils";
#   };

#   outputs =
#     {
#       self,
#       nixpkgs,
#       rust-overlay,
#       flake-utils,
#       ...
#     }:
#     flake-utils.lib.eachDefaultSystem (
#       system:
#       let
#         overlays = [ (import rust-overlay) ];
#         pkgs = import nixpkgs {
#           inherit system overlays;
#         };
#         toolchain = (
#           pkgs.rust-bin.fromRustcRev {
#             rev = "1a5f8bce74ee432f7cc3aa131bc3d6920e06de10";
#             components = {
#               # rustc = "";
#               # rust-src = "";
#             };
#           }
#         );
#       in
#       {
#         devShells.default =
#           with pkgs;
#           mkShell {
#             buildInputs = [
#               openssl
#               pkg-config
#               rust-bin.beta.latest.default
#               toolchain
#             ];
#           };
#       }
#     );
# }
