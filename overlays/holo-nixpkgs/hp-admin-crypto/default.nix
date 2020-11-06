{ pkgs }:

with pkgs;

let
  inherit (rust.packages.nightly) rustPlatform;
  inherit (darwin.apple_sdk.frameworks) Security;
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "hp-admin-crypto";
    rev = "321833b8711d4141de419fa3d1610165621569a5";
    sha256 = "0pssizqpmyxjwzqgkrd3vdg3r30cvz4zwb23zf895rm7djhq52sn";
  };
in

{
  hp-admin-crypto-server = buildRustPackage rustPlatform {
    name = "hp-admin-crypto-server";
    inherit src;
    cargoDir = "server";

    buildInputs = lib.optionals stdenv.isDarwin [ Security ];
  };

  hp-admin-keypair = buildRustPackage rustPlatform {
    name = "hp-admin-keypair";
    inherit src;
    cargoDir = "client";

    nativeBuildInputs = with buildPackages; [
      nodejs
      pkgconfig
      jq
      (wasm-pack.override { inherit rustPlatform; })
    ];
  };
}