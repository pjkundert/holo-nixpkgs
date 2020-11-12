{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.host-console-server;
in

{
  options.services.host-console-server = {
    enable = mkEnableOption "Host Console Server";

    package = mkOption {
      default = pkgs.host-console-server;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.paths.host-console-server-socket-setup = {
      wantedBy = [ "default.target" ];
      pathConfig.PathExists = "/run/host-console-server.sock";
    };

    systemd.services.host-console-server-socket-setup.script = ''
      chgrp hpos-admin-users /run/host-console-server.sock
      chmod g+w /run/host-console-server.sock
      rm -rf /var/lib/holochain-conductor
    '';

    systemd.services.host-console-server = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/host-console-server";
    };

    users.groups.hpos-admin-users = {};
  };
}
