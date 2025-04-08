{
  pkgs,
  teensy-core,
  ...
}: let
  mapAttrs = pkgs.lib.attrsets.mapAttrs;
  teensyLibs = import ./teensy-libs.nix {inherit pkgs;};

  includePaths = builtins.attrValues (mapAttrs (
      name: teensyLib: let
        extraPaths = (
          if builtins.hasAttr "includePaths" teensyLib
          then teensyLib.includePaths
          else []
        );
      in
        builtins.map (path: "${teensyLib.source}/${path}")
        (extraPaths ++ [""])
    )
    teensyLibs);

  sourcePaths = builtins.attrValues (mapAttrs (
      name: teensyLib: let
        extraPaths = (
          if builtins.hasAttr "sourcePaths" teensyLib
          then teensyLib.includePaths
          else []
        );
      in
        builtins.map (path: "${teensyLib.source}/${path}")
        (extraPaths ++ [""])
    )
    teensyLibs);

  env = {
    TEENSY_INCLUDE_PATHS = "${builtins.toString includePaths}";
    TEENSY_SOURCE_PATHS = "${builtins.toString sourcePaths}";
    TEENSY_PATH = "${teensy-core}";
    GCCARM_INCLUDE_PATH = "${pkgs.gcc-arm-embedded}/arm-none-eabi/include";
  };
in
  pkgs.stdenv.mkDerivation {
    inherit includePaths sourcePaths env;
    name = "teensy-firmware";

    src = ../.;

    buildInputs = with pkgs; [
      gcc-arm-embedded
      teensy-core
    ];

    buildPhase = ''
      export CC=arm-none-eabi-gcc
      export CXX=arm-none-eabi-g++
      export OBJCOPY=arm-none-eabi-objcopy
      export SIZE=arm-none-eabi-size

      NO_BEAR=1 make -f ${../Makefile}
    '';

    passthru.env = env;

    installPhase = ''
      mkdir $out
      cp build/*.hex $out/
    '';
  }
