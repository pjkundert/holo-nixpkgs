{ pkgs }: with pkgs;

let
  inherit (rust.packages.nightly) rustPlatform;
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "aorura";
    rev = "2aef90935d6e965cf6ec02208f84e4b6f43221bd";
    sha256 = "00d9c6f0hh553hgmw01lp5639kbqqyqsz66jz35pz8xahmyk5wmw";
  };
in

{
  aorura-cli = buildRustPackage rustPlatform {
    name = "aorura-cli";
    inherit src;
    cargoDir = "cli";
  };

  aorura-emu = buildRustPackage rustPlatform {
    name = "aorura-emu";
    inherit src;
    cargoDir = "emu";
  };
}