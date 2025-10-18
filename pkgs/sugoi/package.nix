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
  version = "0.5.2";
in
rustPlatform.buildRustPackage {
  pname = "sugoi";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "sugoi";
    rev = "v${version}";
    hash = "sha256-bST04v00t8Z2wfGPCFhZXy6shb8vUmDd3QKeYKkS8QE=";
  };

  cargoHash = "sha256-BFwDpa+/o5I0fzCZa6sstBSt7CSmofbNn5Z4/ZL5wRA=";

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
    maintainers = [ { name = "frahz"; } ];
    mainProgram = "sugoi";
  };
}
