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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "sugoi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bST04v00t8Z2wfGPCFhZXy6shb8vUmDd3QKeYKkS8QE=";
  };

  cargoHash = "sha256-BFwDpa+/o5I0fzCZa6sstBSt7CSmofbNn5Z4/ZL5wRA=";

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
