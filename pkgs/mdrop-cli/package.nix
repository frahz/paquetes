{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  ...
}:
let
  version = "0.3.0-2025-08-07";
in
rustPlatform.buildRustPackage {
  pname = "mdrop-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "mdrop";
    rev = "7b2eb5c385ec3e1dc3b1d48b1e75137b8a4e125b";
    hash = "sha256-wdxASiU2snQZHh/UgO5Blitu2kQOzkK4TPNH2jgLBQ0=";
  };

  cargoHash = "sha256-fihzWk9RNZwEuW1qlGZFlWIZB6PBLUlYZd1Nrd/PvQs=";

  cargoBuildFlags = [
    "--bin"
    "mdrop"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Linux CLI tool for controlling Moondrop USB audio dongles.";
    homepage = "https://github.com/frahz/mdrop";
    license = lib.licenses.mit;
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "mdrop";
  };
}
