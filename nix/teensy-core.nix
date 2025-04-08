{
  pkgs,
  libs ? [],
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "teensy-core";
  version = "1.59";

  src = pkgs.fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "cores";
    rev = "${version}";
    sha256 = "sha256-UytiYjAQgiV1YsEesQqS72UT+8mrH1kopTp7CLb37bs=";
  };

  buildInputs = with pkgs; [
    binutils
    gcc-arm-embedded
  ];

  buildPhase = let
    copyLibs = libs: builtins.concatStringsSep "\n" (map (lib: "cp ${lib}/*.{cpp,h} .") libs);
  in ''
    export CC=arm-none-eabi-gcc
    export CXX=arm-none-eabi-g++

    pushd teensy4
    rm main.cpp
    cp ${./MakefileTeensyCore} Makefile
    cp ${./flags.mk} flags.mk

    ${copyLibs libs}

    make

    popd
  '';

  installPhase = ''
    mkdir -p $out/{include,lib}
    pushd teensy4
    cp -r *.h $out/include/
    cp -r avr $out/include/
    cp -r debug $out/include/
    cp -r util $out/include/
    cp libteensy-core.a $out/lib/
    cp ${./flags.mk}  $out/include/flags.mk
    cp imxrt1062.ld $out/include/IMXRT1062.ld
    popd
  '';
}
