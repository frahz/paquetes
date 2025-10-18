{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  ...
}:
let
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  pname = "nemui";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "nemui";
    rev = "v${version}";
    hash = "sha256-rbKSO0j0Fr3WcXzUSyYgcIqiQqgTg2Mzla1Et62HVQ0=";
  };

  cargoHash = "sha256-zP6ABfX8Jveei/v/2JSo98mvqiRs2kWObpa7jVjNimg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This utility is meant to run in the your main server. Once it receives a specific byte over it will put the server to sleep.";
    homepage = "https://git.iatze.cc/frahz/nemui";
    changelog = "https://git.iatze.cc/frahz/nemui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ "frahz" ];
    mainProgram = "nemui";
  };
}
