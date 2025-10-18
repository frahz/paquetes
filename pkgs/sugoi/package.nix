{
  lib,
  rustPlatform,
  makeWrapper,
  sqlite,
  nix-update-script,
  fetchFromGitHub,
  ...
}:
let
  version = "0.5.1";
in
rustPlatform.buildRustPackage {
  pname = "sugoi";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "sugoi";
    rev = "v${version}";
    hash = "sha256-tk0KvETnGngLNoA1L4ZzKzpoKRfni3YHDRiaWcG+w+c=";
  };

  cargoHash = "sha256-imhGGh7gNUq9FRg4Sw2yn9MV5XzgBlYnHsaSot5Thkc=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ sqlite ];

  postInstall = ''
    mkdir -p $out/share
    cp -r assets $out/share
    wrapProgram $out/bin/sugoi \
      --set ASSETS_DIR $out/share/assets
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "small web server for waking up and putting my server to sleep.";
    homepage = "https://git.iatze.cc/frahz/sugoi";
    changelog = "https://git.iatze.cc/frahz/sugoi/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ "frahz" ];
    mainProgram = "sugoi";
  };
}
