{ config, ... }:

let
  nixpkgs = import ../../../nixpkgs/src.nix;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    ../../physical/hpos/holoport
    ../.
  ];

  isoImage.isoBaseName = config.system.build.baseName;
}
