{
  lib,
  rustPlatform,
  stdenv,
  libGL,
  libxkbcommon,
  mdrop-cli,
  wayland,
}:
rustPlatform.buildRustPackage {
  pname = "mdrop-gui";
  inherit (mdrop-cli) version src cargoHash;

  __structuredAttrs = true;

  cargoBuildFlags = [
    "--bin"
    "mdrop-gui"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/mdrop-gui \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  meta = {
    inherit (mdrop-cli.meta)
      homepage
      license
      maintainers
      ;
    description = "Graphical interface for controlling Moondrop USB audio dongles";
    mainProgram = "mdrop-gui";
    platforms = lib.platforms.unix;
  };
}
