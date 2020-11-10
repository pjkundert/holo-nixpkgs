{ pkgs }:

with pkgs;

let
  inherit (rust.packages.nightly) rustPlatform;
in

{

  hpos-config = rustPlatform.buildRustPackage {
    name = "hpos-config";

    src = fetchFromGitHub {
        owner = "Holo-Host";
        repo = "hpos-config";
        rev = "920bd38401edf0b5e81da489d5e519852d7b3218";
        sha256 = "1sc4jhn4h0phxi1pn20c5wq7x8zs3d8dis9il7fdc5iiszki5413";
    };

    cargoSha256 = "0nahfwqh64r6pwl4acayznpld4zcwqdk3g7ys54vfv3gc4033nbg";

    nativeBuildInputs = [ perl ];

    RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
    RUST_SODIUM_SHARED = "1";

    doCheck = false;
  };
}