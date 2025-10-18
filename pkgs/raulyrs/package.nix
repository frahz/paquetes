{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  yt-dlp,
  libopus,
  nix-update-script,
  fetchFromGitHub,
  ...
}:
let
  version = "0.2.1-unstable-2025-10-18";
in
rustPlatform.buildRustPackage {
  pname = "raulyrs";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "rauly.rs";
    rev = "b37043c72037d33883a9a4304394ac9ba5ddded3";
    hash = "sha256-O56cOxf910HmfUNCAUZEJdQyUsQsVtXPa647pPlaPI8=";
  };

  cargoHash = "sha256-IKyuLLQ/iPf5MPfSGNr3I1rrm7lHfkY6++t6JE01pu8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    yt-dlp
    openssl
    libopus
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "rauly.rs discord bot";
    homepage = "https://github.com/frahz/rauly.rs";
    licenses = lib.licenses.mit;
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "raulyrs";
  };
}
