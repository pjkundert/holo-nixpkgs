{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-router-agent;
in

{
  options.services.holo-router-agent = {
    enable = mkEnableOption "Holo Router Agent";

    package = mkOption {
      default = pkgs.holo-router;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holo-router-agent = {
      startAt = "*:0/1";

      serviceConfig = {
        ExecStart = "${pkgs.holo-router}/bin/holo-router-agent";
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
