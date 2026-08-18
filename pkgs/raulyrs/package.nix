{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libopus,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raulyrs";
  version = "0.2.1-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "rauly.rs";
    rev = "b91495d4ec8ee719fa8dae0884f47a4e92554619";
    hash = "sha256-4lqUnPsMHa52cKMAu/7Zj9nnBf4ewbAty6/pMF1jFZA=";
  };

  cargoHash = "sha256-pJecHr+Zkmou71MqFEWKD48kPFZvhvTApjWtRiwDnYY=";

  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
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
    description = "Discord bot written in Rust";
    homepage = "https://github.com/frahz/rauly.rs";
    license = lib.licenses.mit;
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "raulyrs";
    platforms = lib.platforms.linux;
  };
})
