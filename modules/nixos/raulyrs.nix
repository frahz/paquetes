self:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;

  cfg = config.services.raulyrs;
in
{
  options.services.raulyrs = {
    enable = mkEnableOption "rauly.rs discord bot";
    package = mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.raulyrs;
      description = ''
        Package for rauly.rs discord bot
      '';
    };
    environmentFile = mkOption {
      type = lib.types.path;
      description = ''
        Path containing the Bot's API keys.
        The following keys need to be present:
        DISCORD_TOKEN and WORDNIK_API_KEY
      '';
    };
  };
  config = mkIf cfg.enable {
    systemd.services.raulyrs = {
      description = "rauly.rs discord bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.yt-dlp ];
      serviceConfig = {
        Type = "simple";
        User = "raulyrs";
        StateDirectory = "raulyrs";
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = cfg.environmentFile;
        Restart = "always";

        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    users = {
      users.raulyrs = {
        description = "rauly.rs service user";
        isSystemUser = true;
        group = "raulyrs";
      };
      groups.raulyrs = { };
    };
  };
}
