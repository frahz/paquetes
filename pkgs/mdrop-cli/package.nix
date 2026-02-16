{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  ...
}:
let
  version = "0.4.0-unstable-2026-02-12";
in
rustPlatform.buildRustPackage {
  pname = "mdrop-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "mdrop";
    rev = "98d4e36e70aea3a3fb3b390c1523ade1e3da9bc0";
    hash = "sha256-6QuNu3kJl8gs50xUCfE3k6amLOqPU4c1OoBChkBb3Ks=";
  };

  cargoHash = "sha256-B11v2A079auETcFxBcLlDcrEobCpf2V9hkIDRAppqRE=";

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
