{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hpos-admin;
in

{
  options.services.hpos-admin = {
    enable = mkEnableOption "HPOS Admin";

    package = mkOption {
      default = pkgs.hpos-admin;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hpos-admin = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hpos-admin";
        User = "hpos-admin-api";
        Group = "hpos-api-group";
      };
    };

    systemd.tmpfiles.rules = [
      "d /run/hpos-admin-api 0770 hpos-admin-api hpos-api-group - -"
    ];

    users.users.hpos-admin-api = {
      isSystemUser = true;
      group = "hpos-api-group";
    };
  };
}
