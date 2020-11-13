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
    systemd.paths.hpos-holochain-api-socket-setup = {
      wantedBy = [ "default.target" ];
      pathConfig.PathExists = "/run/hpos-holochain-api.sock";
    };

    systemd.services.hpos-holochain-api-socket-setup.script = ''
      chgrp hpos-admin-users /run/hpos-holochain-api.sock
      chmod g+w /run/hpos-holochain-api.sock
      rm -rf /var/lib/holochain-conductor
    '';

    systemd.services.hpos-holochain-api = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/hpos-holochain-api";
    };

    users.groups.hpos-admin-users = {};
  };
}
