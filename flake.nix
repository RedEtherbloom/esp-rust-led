{
  description = "Experimenting with esp_hal and openrgb.";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            esp-generate
            espflash
            probe-rs-tools
            (inputs'.fenix.packages.fromToolchainFile {
              file = ./rust-toolchain.toml;
              sha256 = "sha256-vra6TkHITpwRyA5oBKAHSX0Mi6CBDNQD+ryPSpxFsfg=";
            })
          ];
        };
      };
    };
}
