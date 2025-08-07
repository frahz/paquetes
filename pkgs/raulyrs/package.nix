{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  yt-dlp,
  libopus,
  fetchFromGitHub,
  ...
}:
let
  version = "0.2.0-2025-08-06";
in
rustPlatform.buildRustPackage {
  pname = "raulyrs";
  inherit version;

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "rauly.rs";
    rev = "ed7ad008106c772a298dd39c987e25b7d6ee78af";
    hash = "sha256-R9KjQYN6iPqU89M8TILHZooX1pUddTMn1wMrDe+Jlcw=";
  };

  cargoHash = "sha256-APEs+pWF97EZlWvcqU3OZwIJjU4OLDwnRd/hmmKv6MM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    yt-dlp
    openssl
    libopus
  ];

  meta = {
    description = "rauly.rs discord bot";
    homepage = "https://github.com/frahz/rauly.rs";
    licenses = lib.licenses.mit;
    maintainers = [ "frahz" ];
    mainProgram = "raulyrs";
  };
}
