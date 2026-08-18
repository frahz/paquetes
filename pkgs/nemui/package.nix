{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nemui";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "nemui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6LO9nFW4BlnAGYdWLnNugraswROeIpA62BLyClBwfOs=";
  };

  cargoHash = "sha256-of66sIP27c5R9OndYZ0oWyE8IeImMLj7LLEBS9UHzoc=";

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network daemon for remotely suspending a server";
    homepage = "https://git.iatze.cc/frahz/nemui";
    changelog = "https://git.iatze.cc/frahz/nemui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "nemui";
    platforms = lib.platforms.linux;
  };
})
