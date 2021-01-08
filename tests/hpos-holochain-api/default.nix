{ makeTest, lib, hpos, hpos-holochain-client, hpos-config, jq }:

makeTest {
  name = "hpos-holochain-api";

  machine = {
    imports = [ (import "${hpos.logical}/sandbox") ];

    documentation.enable = false;

    environment.systemPackages = [
      hpos-holochain-client
      hpos-config  # TODO: now inside hpos-config package
      jq
    ];

    /* services.hpos-holochain-api.enable = true; */
    services.holochain.config.enable = true;

    /* services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/jack/".proxyPass = "http://unix:/run/hpos-holochain-api/hpos-holochain-api.sock:/";
      };
    }; */

    systemd.services.holochain.environment.HPOS_CONFIG_PATH = "/etc/hpos-config.json";

    users.users.nginx.extraGroups = [ "apis" ];

    virtualisation.memorySize = 3072;
  };

  testScript = ''
    start_all()

    machine.succeed(
        "hpos-config-gen-cli --email test\@holo.host --password : --seed-from ${./seed.txt} > /etc/hpos-config.json"
    )
    machine.succeed("systemctl restart holochain.service")
    machine.wait_for_unit("holochain.service")
    machine.wait_for_open_port("42233")

    machine.shutdown()
  '';

  meta.platforms = [ "x86_64-linux" ];
}
