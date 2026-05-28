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
  version = "0.2.1-unstable-2026-04-29";
in
rustPlatform.buildRustPackage {
  pname = "raulyrs";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "rauly.rs";
    rev = "b91495d4ec8ee719fa8dae0884f47a4e92554619";
    hash = "sha256-4lqUnPsMHa52cKMAu/7Zj9nnBf4ewbAty6/pMF1jFZA=";
  };

  cargoHash = "sha256-pJecHr+Zkmou71MqFEWKD48kPFZvhvTApjWtRiwDnYY=";

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
