self:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;

  cfg = config.services.nemui;
in
{
  options.services.nemui = {
    enable = mkEnableOption "nemui daemon";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.nemui;
      description = "The package to use for nemui";
    };
    port = mkOption {
      type = lib.types.port;
      default = 8253;
      description = "The port to open for nemui";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.nemui = {
      enable = true;
      description = "Nemui sleep service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        # DynamicUser = true;
        ExecStart = lib.getExe cfg.package;

        # AmbientCapabilities = [ "CAP_SYS_BOOT" ];
        # CapabilityBoundingSet = [ "CAP_SYS_BOOT" ];
        # LockPersonality = true;
        # NoNewPrivileges = true;
        # PrivateDevices = true;
        # PrivateIPC = true;
        # PrivateTmp = true;
        # PrivateUsers = true;
        # ProtectClock = true;
        # ProtectControlGroups = true;
        # ProtectHome = true;
        # ProtectHostname = true;
        # ProtectKernelLogs = true;
        # ProtectKernelModules = true;
        # ProtectKernelTunables = true;
        # ProtectProc = "invisible";
        # ProtectSystem = "strict";
        # RestrictRealtime = true;
        # SystemCallArchitectures = "native";
        # SystemCallFilter = [
        #   "@system-service"
        #   "reboot"
        # ];
        # UMask = "0077";
      };
    };
  };
}
