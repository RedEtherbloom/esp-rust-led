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
            # TODO: Initialize from rust-toolchain.toml instead to make project indepent of nix
            inputs'.fenix.packages.targets."riscv32imac-unknown-none-elf".stable.completeToolchain
          ];
        };
      };
    };
}
