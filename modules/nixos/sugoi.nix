self:
{
  inputs,
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
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.sugoi;
    };
    port = mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''The Port which sugoi service will listen on.'';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

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
        StateDirectory = "sugoi";
        ExecStart = lib.getExe cfg.package;
      };
    };
  };
}
