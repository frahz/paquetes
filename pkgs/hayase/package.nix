{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  ...
}:
appimageTools.wrapType2 rec {
  pname = "hayase";
  version = "6.4.45";

  src = fetchurl {
    url = "https://api.hayase.watch/files/linux-hayase-${version}-linux.AppImage";
    hash = "sha256-CeCI3OwotJW5LMvQnp9NJMceZDrSxaf0eT87EJpG368=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/hayase"
      cp -r ${contents}/{locales,resources} "$out/share/lib/hayase"
      cp -r ${contents}/usr/share/* "$out/share"
      cp "${contents}/${pname}.desktop" "$out/share/applications/"
      wrapProgram $out/bin/hayase --add-flags "--ozone-platform=wayland"
      substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Hayase - Torrent streaming made simple";
    homepage = "https://hayase.watch";
    changelog = "https://hayase.watch/changelog";
    license = lib.licenses.bsl11;
    mainProgram = "hayase";
  };
}
