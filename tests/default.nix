{ pkgs ? import ../. {} }:

with pkgs;

let
  testing = import "${pkgs.path}/nixos/lib/testing-python.nix" {
    inherit pkgs system;
  };

  callPackage = newScope (pkgs // testing);
in

{
  # TODO: fix/port/review these
  # hpos-admin-api = callPackage ./hpos-admin-api {};
  # holochain = callPackage ./holochain {};
  hpos-holochain-api = callPackage ./hpos-holochain-api {};
}
