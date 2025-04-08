{
  description = "Build environment for Teensy 4.0 with Arduino/Teensyduino";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        teensy-core = import ./nix/teensy-core.nix {inherit pkgs;};
        firmware = import ./nix/build.nix {inherit pkgs teensy-core;};

        flash = pkgs.writeScriptBin "flash-firmware" ''
          #!/bin/sh
          echo "Flashing... (Press button to put Teensy into loading mode)"
          ${pkgs.teensy-loader-cli}/bin/teensy-loader-cli --mcu=TEENSY40 -w ${firmware}/firmware.hex
        '';
      in {
        packages.default = firmware;
        packages.flash = flash;

        apps.default = {
          type = "app";
          program = "${flash}/bin/flash-firmware";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [firmware];
          buildInputs = with pkgs; [
            teensy-loader-cli
            clang
            bear
          ];
          env = {} // firmware.env;
        };
      }
    );
}
