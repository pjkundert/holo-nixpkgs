{ config, lib, pkgs, ... }:

with pkgs;

let
  conductorHome = "/var/lib/holochain-conductor";
in

{
  imports = [ ../. ];

  services.holo-auth-client.enable = false;

  services.holo-router-agent.enable = false;

  services.hpos-init.enable = false;

  services.zerotierone.enable = false;

  system.holo-nixpkgs.autoUpgrade.enable = false;

  system.holo-nixpkgs.usbReset.enable = false;

  services.holochain-conductor = {
    enable = true;
    config = {
      network = {};
      logger = {
        state_dump = false;
        type = "debug";
        /* rules = {
          rules= [
          {
            exclude= true;
            pattern= ".*parity.*";
          }
          {
            exclude= true;
            pattern= ".*mio.*";
          }
          {
            exclude= true;
            pattern= ".*tokio.*";
          }
          {
            exclude= true;
            pattern= ".*hyper.*";
          }
          {
            exclude= true;
            pattern= ".*rusoto_core.*";
          }
          {
            exclude= true;
            pattern= ".*want.*";
          }
          {
            exclude= true;
            pattern= ".*rpc.*";
          }
          ];
        }; */
      };
      persistence_dir = conductorHome;
      signing_service_uri = "http://localhost:9676";
      interfaces = [
        {
          id = "master-interface";
          admin = true;
          driver = {
            port = 42211;
            type = "websocket";
          };
        }
        {
          id = "internal-interface";
          admin = false;
          driver = {
            port = 42222;
            type = "websocket";
          };
        }
        {
          id = "admin-interface";
          admin = false;
          driver = {
            port = 42233;
            type = "websocket";
          };
        }
        {
          id = "hosted-interface";
          admin = false;
          driver = {
            port = 42244;
            type = "websocket";
          };
        }
      ];
    };
  };


}
