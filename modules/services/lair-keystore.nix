{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lair-keystore;
  holochain-home = config.services.holochain-conductor.working-directory;
in

{
  options.services.lair-keystore = {
    enable = mkEnableOption "Lair Keystore";

    package = mkOption {
      default = pkgs.lair-keystore;
      type = types.package;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [ cfg.package ];

    systemd.services.lair-keystore = {
      after = [ "network.target" "holochain-conductor.service" ];
      requires = [ "holochain-conductor.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "holochain-conductor";
        Group = "holochain-conductor";
        ExecStart = "${cfg.package}/bin/lair-keystore -d ${cfg.working-directory}";
        StateDirectory = "holochain-conductor";
      };
    };

    users.groups.lair-keystore = {};
  };
}
