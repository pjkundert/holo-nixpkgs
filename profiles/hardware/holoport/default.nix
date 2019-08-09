{ lib, ... }:

{
  imports = [ ../. ];

  boot.loader.grub = {
    enable = lib.mkDefault true;
    devices = [ "/dev/sda" ];
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";

  services.holoport-led-daemon = {
    device = "/dev/ttyUSB0";
    operstate = "/sys/class/net/enp1s0/operstate";
  };

  system.holoportos.target = "holoport";
}
