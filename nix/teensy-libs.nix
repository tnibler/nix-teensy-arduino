{pkgs, ...}: {
  # Teensy libraries can be added here. They will be included automatically by the Makefile.

  ws2812serial = {
    source = pkgs.fetchFromGitHub {
      owner = "PaulStoffregen";
      repo = "WS2812Serial";
      rev = "e88f59cb9c27090a690737c2c9d3c5cca96b4fe7";
      sha256 = "sha256-FMmQ/jc6nVB2Qtw678NCjXkLbzkkyKtia4JSM5A01z4=";
    };
  };

  # audio = {
  #   source = pkgs.fetchFromGitHub {
  #     owner = "PaulStoffregen";
  #     repo = "Audio";
  #     rev = "bd7de878a802841857a762e855e55fcc9da37fa2";
  #     sha256 = "sha256-5xTQLTfYf/xcgaTBBsDD7cDIpfJBTm9RpKu5UBOvtQc=";
  #     # Don't need stuff related to SD/Flash storage so remove it
  #     postFetch = ''
  #       pushd $out
  #       rm -f *play* *sd* *flash* *control* *synth*
  #       sed -i '/play\|flash\|sd\|control\|synth/d' Audio.h
  #       rm -rf docs examples gui
  #     '';
  #   };
  #   # If there are additional source/header files in subdirectories (not just the repo root), add them here.
  #   includePaths = ["utility"];
  #   sourcePaths = ["utility"];
  # };
  #
  # spi = {
  #   source = pkgs.fetchFromGitHub {
  #     owner = "PaulStoffregen";
  #     repo = "SPI";
  #     rev = "52f8402bb62c56a0d5fabea20c056f584a703c9a";
  #     sha256 = "sha256-Ph/Wo6Y2k0JMsx7Gv2bgxRZMjUsExv54OFOpbsfDsDw=";
  #   };
  # };
}
