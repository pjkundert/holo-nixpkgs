{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain-conductor;
in

{
  options.services.holochain-conductor = {
    enable = mkEnableOption "Holochain";

    config = mkOption {
      type = types.attrs;
    };

    package = mkOption {
      default = pkgs.holochain;
      type = types.package;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [ cfg.package ];

    systemd.services.holochain-conductor = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''

      '';

      serviceConfig = {
        User = "holochain-conductor";
        Group = "holochain-conductor";
        ExecStart = "${cfg.package}/bin/holochain -c /var/lib/holochain-conductor/conductor-config.toml";
        StateDirectory = "holochain-conductor";
      };
    };

    users.users.holochain-conductor = {
      isSystemUser = true;
      home = "/var/lib/holochain-conductor";
      # ensures directory is owned by user
      createHome = true;
    };

    users.groups.holochain-conductor = {};
  };
}
