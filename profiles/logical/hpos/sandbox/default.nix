{ config, lib, pkgs, ... }:

with pkgs;

let
  holochainWorkingDir = "/var/lib/holochain-rsm";
in

{
  imports = [ ../. ];

  services.holo-auth-client.enable = false;

  services.holo-router-agent.enable = false;

  services.hpos-init.enable = false;

  services.holo-envoy.enable = false;

  services.zerotierone.enable = false;

  system.holo-nixpkgs.autoUpgrade.enable = false;

  system.holo-nixpkgs.usbReset.enable = false;

  services.holochain = {
    enable = true;
    working-directory = holochainWorkingDir;
    config = {
      environment_path = "${holochainWorkingDir}/databases";
      keystore_path = "${holochainWorkingDir}/lair-keystore";
      use_dangerous_test_keystore = false;
      admin_interfaces = [
        {
          driver = {
            type = "websocket";
            port = 4444;
          };
        }
      ];
      network = {
        bootstrap_service = "https://bootstrap.holo.host";
        transport_pool = [{
          type = "quic";
          # TODO: Figure out why this is panicking in tests
          /* type = "proxy";
          sub_transport = {
            type = "quic";
          };
          proxy_config = {
            type = "remote_proxy_client";
            proxy_url = "kitsune-proxy://nFCWLsuRC0X31UMv8cJxioL-lBRFQ74UQAsb8qL4XyM/kitsune-quic/h/proxy.holochain.org/p/5775/--";
          }; */
        }];
      };
    };
  };

  services.lair-keystore.enable = true;

}
