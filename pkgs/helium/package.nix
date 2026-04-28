{
  lib,
  appimageTools,
  fetchurl,
  widevine-cdm,
  writeScript,
  ...
}:
appimageTools.wrapAppImage rec {
  pname = "helium";
  version = "0.11.5.1";

  src = appimageTools.extract {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
      hash = "sha256-Ni7IZ9UBafr+ss0BcQaRKqmlmJI4IV1jRAJ8jhcodlg=";
    };

    postExtract = ''
      mkdir -p $out/opt/helium
      cp -a ${widevine-cdm}/share/google/chrome/WidevineCdm $out/opt/helium
    '';
  };

  extraInstallCommands = ''
    install -Dm444 {${src},$out/share/applications}/helium.desktop
    install -Dm444 {${src}/usr,$out}/share/icons/hicolor/256x256/apps/helium.png
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
    downloadPage = "https://github.com/imputnet/helium-linux/releases";
    mainProgram = "helium";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
