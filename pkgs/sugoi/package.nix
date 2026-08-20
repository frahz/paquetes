{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  makeWrapper,
  sqlite,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sugoi";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "sugoi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7dl814ZQooLqTJXP/Ma+b2D/gIAZe/2m3mkFA4/a5T0=";
  };

  cargoHash = "sha256-9XIqBcbR4lsiEaAPpuqCo73Qix7+NA/ajcG0OoIdTr0=";

  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ sqlite ];

  postInstall = ''
    install -Dm644 -t $out/share/${finalAttrs.pname} assets/*
    wrapProgram $out/bin/sugoi \
      --set-default ASSETS_DIR $out/share/${finalAttrs.pname}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web interface for remotely waking and suspending servers";
    homepage = "https://git.iatze.cc/frahz/sugoi";
    changelog = "https://git.iatze.cc/frahz/sugoi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "sugoi";
    platforms = lib.platforms.linux;
  };
})
