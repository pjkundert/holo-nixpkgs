{
  imports = [
    ./boot/generic-extlinux-compatible.nix
    ./services/holoport-led.nix

    # TODO: switch to node2nix
    # ./services/envoy.nix

    # TODO: fix compat with HoloPort Nano
    # ./services/holo-health.nix
  ];
}
