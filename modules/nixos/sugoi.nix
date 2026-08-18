{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;

  cfg = config.services.sugoi;
in
{
  options.services.sugoi = {
    enable = mkEnableOption "sugoi daemon";
    package = mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../pkgs/sugoi/package.nix { };
    };
    port = mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The port on which the sugoi service listens";
    };
    openFirewall = mkEnableOption "opening sugoi's TCP port in the firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.sugoi = {
      description = "sugoi wakeup service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        PORT = toString cfg.port;
        SUGOI_DB_PATH = "/var/lib/sugoi/sugoi.db";
      };
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "sugoi";
        ExecStart = lib.getExe cfg.package;
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
  };
}
