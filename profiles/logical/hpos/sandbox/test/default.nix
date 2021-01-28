{ config, lib, pkgs, ... }:

with pkgs;

let
  hposConfigPath = "/etc/hpos/config.json";
in

{
  imports = [ ../. ];

  documentation.enable = false;

  environment.systemPackages = [
    hpos-config
    jq
  ];

  environment.variables.HPOS_CONFIG_PATH = hposConfigPath;

  services.nginx.enable = true;

  systemd.globalEnvironment.HPOS_CONFIG_PATH = hposConfigPath;

  users.users.nginx.extraGroups = [ "apis" ];

  virtualisation.memorySize = 3072;
}

 