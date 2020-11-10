{ pkgs }:

with pkgs;

let
  inherit (rust.packages.nightly) rustPlatform;
  inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "hpos-config";
    rev = "920bd38401edf0b5e81da489d5e519852d7b3218";
    sha256 = "1sc4jhn4h0phxi1pn20c5wq7x8zs3d8dis9il7fdc5iiszki5413";
  };
in

{
  hpos-config-gen-cli = rustPlatform.buildRustPackage {
    name = "hpos-config-gen-cli";
    inherit src;
    cargoDir = "gen-cli";

    buildInputs = lib.optionals stdenv.isDarwin [ Security ];

    doCheck = false;
  };

  hpos-config-gen-web = rustPlatform.buildRustPackage rec {
    name = "hpos-config-gen-web";
    inherit src;
    cargoDir = "gen-web";

    nativeBuildInputs = with buildPackages; [
      nodejs-12_x
      pkgconfig
      (wasm-pack.override { inherit rustPlatform; })
    ];

    buildInputs = [ openssl ];

    buildPhase = ''
      cp -r ${npmToNix { src = "${src}/${cargoDir}"; }} node_modules
      chmod -R +w node_modules
      chmod +x node_modules/.bin/webpack
      patchShebangs node_modules
      npm run build
    '';

    installPhase = ''
      mv dist $out
    '';

    doCheck = false;
  };

  hpos-config-into-base36-id = rustPlatform.buildRustPackage {
    name = "hpos-config-into-base36-id";
    inherit src;
    cargoDir = "into-base36-id";

    buildInputs = lib.optionals stdenv.isDarwin [ Security ];

    doCheck = false;
  };

  hpos-config-into-keystore = rustPlatform.buildRustPackage {
    name = "hpos-config-into-keystore";
    inherit src;
    cargoDir = "into-keystore";

    RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
    RUST_SODIUM_SHARED = "1";

    nativeBuildInputs = with buildPackages; [ perl ];
    buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

    doCheck = false;
  };

  hpos-config-is-valid = rustPlatform.buildRustPackage {
    name = "hpos-config-is-valid";
    inherit src;
    cargoDir = "is-valid";

    buildInputs = lib.optionals stdenv.isDarwin [ Security ];

    doCheck = false;
  };
}