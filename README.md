# Nix template for Teensy 4.0, using Arduino

Build firmware: `nix build`

Build and flash: `nix run`

Source `.cpp` files can be placed in `src/`.

For a development environment, use `nix develop` and `make` to build, `make flash` to flash.

The `clangd` language server is configured to find Arduino/Teensy libraries. You have to run `make` once to generate `compile_commands.json` for `clangd` to use.

Additional teensy libraries (found at [PaulStoffregen](https://github.com/PaulStoffregen/)) can be added to `nix/teensy-libs.nix` and are automatically included by the Makefile.

## Support

No support provided, I don't understand nix either lol. If you have improvements feel free to share though :-)

## License

MIT Licensed.

Based on: https://blog.kummerlaender.eu/article/reproducible_development_environment_teensy/
