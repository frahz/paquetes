{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  ...
}:
let
  version = "0.3.1";
in
rustPlatform.buildRustPackage {
  pname = "nemui";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "nemui";
    rev = "v${version}";
    hash = "sha256-6LO9nFW4BlnAGYdWLnNugraswROeIpA62BLyClBwfOs=";
  };

  cargoHash = "sha256-of66sIP27c5R9OndYZ0oWyE8IeImMLj7LLEBS9UHzoc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This utility is meant to run in the your main server. Once it receives a specific byte over it will put the server to sleep.";
    homepage = "https://git.iatze.cc/frahz/nemui";
    changelog = "https://git.iatze.cc/frahz/nemui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "nemui";
  };
}
