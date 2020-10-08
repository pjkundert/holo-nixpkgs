{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain;
in

{
  options.services.holochain = {
    enable = mkEnableOption "Holochain";

    config = mkOption {
      type = types.attrs;
    };

    package = mkOption {
      default = pkgs.holochain;
      type = types.package;
    };

    working-directory = mkOption {
      default = "";
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [ cfg.package ];

    systemd.services.holochain = {
      after = [ "network.target" "lair-keystore.service" ];
      requires = [ "lair-keystore.service" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [[ ! -f $STATE_DIRECTORY/holochain-config.toml ]]; then
          ${pkgs.envsubst}/bin/envsubst < ${pkgs.writeTOML cfg.config} > $STATE_DIRECTORY/holochain-config.toml
        fi
      '';

      serviceConfig = {
        User = "holochain-rsm";
        Group = "holochain-rsm";
        ExecStart = "${cfg.package}/bin/holochain -c ${cfg.working-directory}/holochain-config.toml";
        StateDirectory = "holochain-rsm";
      };
    };

    users.users.holochain-rsm = {
      isSystemUser = true;
      home = "${cfg.working-directory}";
      # ensures directory is owned by user
      createHome = true;
    };

    users.groups.holochain-rsm = {};
  };
}
