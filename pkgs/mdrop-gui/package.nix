{
  lib,
  rustPlatform,
  callPackage,
  stdenv,
  libGL,
  libxkbcommon,
  wayland,
}:
let
  # TODO: figure out how to fix this
  mdrop-cli = callPackage ../mdrop-cli/package.nix { };
in
rustPlatform.buildRustPackage {
  pname = "mdrop-gui";
  inherit (mdrop-cli) version src cargoHash;

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
      description
      homepage
      license
      maintainers
      ;
    mainProgram = "mdrop-gui";
  };
}
