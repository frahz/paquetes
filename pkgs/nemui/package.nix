{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nemui";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "nemui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-is/HGStyPKefxRMnIY4JZHHvRAzcyF+nkQeipkcQiwo=";
  };

  cargoHash = "sha256-ItZQ9e7sfCOCmk0hUxEWQnUdsCnEPWCGtrOE8/8OiRQ=";

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
