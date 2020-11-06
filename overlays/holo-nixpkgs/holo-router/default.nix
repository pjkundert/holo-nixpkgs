{ pkgs }:

with pkgs;

let
  inherit (rust.packages.nightly) rustPlatform;
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-router";
    rev = "01421a799a2df06272307fc322f86e73595ff006";
    sha256 = "1qv9h82gl8lcm3kbkkq0gskd38c5msp9lxz5hvaxj6q8amc8884v";
  };
in

{
  holo-router-agent = buildRustPackage rustPlatform {
    name = "holo-router-agent";
    inherit src;
    cargoDir = "./agent";

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];

    meta.platforms = lib.platforms.linux;
  };

  holo-router-gateway = buildRustPackage rustPlatform {
    name = "holo-router-gateway";
    inherit src;
    cargoDir = "./gateway";

    meta.platforms = lib.platforms.linux;
  };
}