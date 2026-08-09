{
  lib,
  appimageTools,
  fetchurl,
  widevine-cdm,
  writeScript,
  ...
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "helium";
  version = "0.15.3.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${finalAttrs.version}/helium-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-ZCCm/prkgYgbDHW6OBPWvoIE77g7IYQpYdqc/PnIrSU=";
  };

  extraInstallCommands = ''
    mkdir -p $out/opt/helium
    cp -a ${widevine-cdm}/share/google/chrome/WidevineCdm $out/opt/helium
    install -Dm444 {${finalAttrs.contents},$out/share/applications}/helium.desktop
    install -Dm444 {${finalAttrs.contents}/usr,$out}/share/icons/hicolor/256x256/apps/helium.png
  '';

  # TODO: check if needed
  extraBwrapArgs = [
    "--ro-bind-try /etc/chromium/policies/managed/default.json /etc/chromium/policies/managed/default.json"
    "--ro-bind-try /etc/xdg/ /etc/xdg/"
  ];

  passthru.updateScript = writeScript "helium-update" (builtins.readFile ./update.sh);

  meta = {
    description = "Helium Browser";
    homepage = "https://github.com/imputnet/helium-linux";
    downloadPage = "https://github.com/imputnet/helium-linux/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/imputnet/helium-linux/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      bsd3
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "helium";
    platforms = [ "x86_64-linux" ];
  };
})
