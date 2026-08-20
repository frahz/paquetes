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
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.user === "nemui" &&
            (
              action.id === "org.freedesktop.login1.suspend" ||
              action.id === "org.freedesktop.login1.suspend-multiple-sessions"
            )
          ) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 8253 ];

    systemd.services.nemui = {
      description = "Nemui sleep service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.systemd ];
      serviceConfig = {
        Type = "simple";
        User = "nemui";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProcSubset = "pid";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = "tcp:8253";
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
