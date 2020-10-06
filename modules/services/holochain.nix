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
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [[ ! -f $STATE_DIRECTORY/conductor-config.toml ]]; then
          ${pkgs.envsubst}/bin/envsubst < ${pkgs.writeTOML cfg.config} > $STATE_DIRECTORY/conductor-config.toml
        fi
      '';

      serviceConfig = {
        User = "holochain-rsm";
        Group = "holochain-rsm";
        ExecStart = "${cfg.package}/bin/holochain -c ${cfg.working-directory}/conductor-config.toml";
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
