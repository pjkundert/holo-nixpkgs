{ config, lib, pkgs, ... }:

with pkgs;

let
  holochainWorkingDir = "/var/lib/holochain-rsm";

  configureHolochainWorkingDir = "/var/lib/configure-holochain";
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

  services.configure-holochain = {
    enable = true;
    working-directory = configureHolochainWorkingDir;
    install-list = {
      core_happs = [
        {
          app_id = "core-happs";
          version = "alpha0";
          dna_url = "https://holo-host.github.io/holo-hosting-app-rsm/releases/downloads/v0.0.1-alpha5/holo-hosting-app.dna.gz"; # this version mismatch is on purpose for hash alteration
        }
        /* {
          app_id = "servicelogger";
          version = "alpha1";
          ui_url = "https://github.com/holochain/elemental-chat-ui/releases/download/v0.0.1-alpha19/elemental-chat.zip";
          dna_url = "https://github.com/holochain/elemental-chat/releases/download/v0.0.1-alpha13/elemental-chat.dna.gz"; # this version mismatch is on purpose for hash alteration
        } */
      ];
      self_hosted_happs = [
        /* {
          app_id = "elemental-chat";
          version = "alpha14";
          ui_url = "https://github.com/holochain/elemental-chat-ui/releases/download/v0.0.1-alpha19/elemental-chat.zip";
          dna_url = "https://github.com/holochain/elemental-chat/releases/download/v0.0.1-alpha13/elemental-chat.dna.gz"; # this version mismatch is on purpose for hash alteration
        } */
      ];
    };
  };

  services.lair-keystore.enable = true;

}
