{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig, lib, callPackage }:

rec {
  mkHolochainBinary = {
        version ? "2020-12-17"
      , rev ? "a761c76c0b37ac7fd9495c6e36d9fbd2215dfdc2"
      , sha256 ? "037s95rzdvxl9nakhjyj0jqbgrw1v0bmngfspbakw97hlva4j2kd"
      , cargoSha256 ? "0x7pi63xi1hm096vklzn25ziwzq28c2hprd90r4sgw847jkamz74"
      , crate
      , ... } @ overrides: rustPlatform.buildRustPackage (lib.attrsets.recursiveUpdate {
    name = "holochain";

    src = fetchFromGitHub {
      owner = "holochain";
      repo = "holochain";
      inherit rev sha256;
    };

    inherit cargoSha256;

    cargoBuildFlags = [
      "--no-default-features"
      "--manifest-path=crates/${crate}/Cargo.toml"
    ];

    nativeBuildInputs = [ perl pkgconfig ];

    buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
      CoreServices
      Security
    ];

    RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
    RUST_SODIUM_SHARED = "1";

    doCheck = false;
  } (builtins.removeAttrs overrides [
    "rev"
    "sha256"
    "cargoSha256"
    "crate"
  ]));

  holochain = mkHolochainBinary {
    crate = "holochain";
  };
}
