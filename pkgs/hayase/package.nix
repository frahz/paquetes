{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  writeScript,
  ...
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "hayase";
  version = "6.4.86";

  src = fetchurl {
    url = "https://api.hayase.watch/files/linux-hayase-${finalAttrs.version}-linux.AppImage";
    hash = "sha256-Qdi5NO8G8JLUFNDJoCvnM/zZsDlEPn3/GnKAoAosG+0=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/hayase"
    cp -r ${finalAttrs.contents}/{locales,resources} "$out/share/lib/hayase"
    cp -r ${finalAttrs.contents}/usr/share/* "$out/share"
    cp "${finalAttrs.contents}/${finalAttrs.pname}.desktop" "$out/share/applications/"
    wrapProgram $out/bin/hayase --add-flags "--ozone-platform=wayland"
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${finalAttrs.meta.mainProgram}'
  '';

  passthru = {
    updateScript = writeScript "hayase-update" (builtins.readFile ./update.sh);
  };

  meta = {
    description = "Hayase - Torrent streaming made simple";
    homepage = "https://hayase.watch";
    changelog = "https://hayase.watch/changelog";
    license = lib.licenses.bsl11;
    mainProgram = "hayase";
  };
})
