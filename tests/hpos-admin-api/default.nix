{ makeTest, lib, hpos, hpos-admin-client }:

makeTest {
  name = "hpos-admin-api";

  machine.imports = [ (import "${hpos.logical}/sandbox/test") ];

  testScript = ''
    import json

    start_all()

    machine.succeed("mkdir /etc/hpos")
    machine.succeed("chgrp apis /etc/hpos")
    machine.succeed("chmod g+rwx /etc/hpos")
    machine.succeed(
        "hpos-config-gen-cli --email test\@holo.host --password : --seed-from ${./seed.txt} > /etc/hpos/config.json"
    )

    machine.succeed("systemctl start hpos-admin-api.service")
    machine.wait_for_unit("hpos-admin-api.service")
    machine.wait_for_file("/run/hpos-admin-api/hpos-admin-api.sock")

    machine.succeed(
        "hpos-admin-client --url=http://localhost/hpos-admin-api/ put-settings example KbFzEiWEmM1ogbJbee2fkrA1"
    )
    expected_settings = {
        "admin": {
            "email": "test@holo.host",
            "public_key": "zQJsyuGmTKhMCJQvZZmXCwJ8/nbjSLF6cEe0vNOJqfM",
        },
        "example": "KbFzEiWEmM1ogbJbee2fkrA1",
    }
    actual_settings = json.loads(
        machine.succeed(
            "hpos-admin-client --url=http://localhost/hpos-admin-api/ get-settings"
        )
        .strip()
        .replace("'", '"')
    )
    assert actual_settings == expected_settings, "unexpected settings"

    machine.shutdown()
  '';

  meta.platforms = [ "x86_64-linux" ];
}
