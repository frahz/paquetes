{
  lib,
  rustPlatform,
  callPackage,
  makeWrapper,
  libGL,
  libxkbcommon,
  wayland,
}:
let
  # TODO: figure out how to fix this
  mdrop-cli = callPackage ../mdrop-cli/package.nix { };

  libPath = lib.makeLibraryPath [
    libGL
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage {
  pname = "mdrop-gui";
  inherit (mdrop-cli) version src cargoHash;

  cargoBuildFlags = [
    "--bin"
    "mdrop-gui"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mdrop-gui --prefix LD_LIBRARY_PATH : ${libPath}
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
