{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hpos-holochain-api;
in

{
  options.services.hpos-holochain-api = {
    enable = mkEnableOption "Host Console Server";

    package = mkOption {
      default = pkgs.hpos-holochain-api;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hpos-holochain-api = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.nodejs}/bin/node ${cfg.package}/main.js --app-port=42233 --app-id=core-hha";
        User = "hpos-holochain-api";
        Group = "hpos-api-group";
        UMask = "0002";
      };
    };

    systemd.tmpfiles.rules = [
      "d /run/hpos-holochain-api 0770 hpos-holochain-api hpos-api-group - -"
    ];

    users.users.hpos-holochain-api = {
      isSystemUser = true;
      group = "hpos-api-group";
    };
  };
}
