{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.services.nemui;
in
{
  options.services.nemui = {
    enable = mkEnableOption "nemui daemon";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../pkgs/nemui/package.nix { };
      description = "The package to use for nemui";
    };
    openFirewall = mkEnableOption "opening nemui's TCP port in the firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 8253 ];

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
