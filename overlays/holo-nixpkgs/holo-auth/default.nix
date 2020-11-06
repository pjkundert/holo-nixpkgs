{ pkgs }:

with pkgs;

let
  inherit (rust.packages.nightly) rustPlatform;
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-auth";
    rev = "43009e8ab644621dd4272c4723d0e603412f062b";
    sha256 = "1c8p9xjhfxgh11vf55fwkglffv0qjc8gzc98kybqznhm81l8y2fl";
  };
in

{
  holo-auth-client = buildRustPackage rustPlatform {
    name = "holo-auth-client";
    inherit src;
    cargoDir = "client";

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];

    meta.platforms = lib.platforms.linux;
  };
}