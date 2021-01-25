{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig, lib, callPackage }:

rec {
  mkHolochainBinary = {
        version ? "2020-12-17"
      , rev ? "75e9620343f64f3c6a3b82c2c4156255bebcf0cb"
      , sha256 ? "144fyhvfhz233vjl54nz2l5kxrn9as4ga2f6y4waqyaba73ads4r"
      , cargoSha256 ? "10as0sv0x79ynvb2j0896lfirqbngx5fqhbkdwqkgrv0ab59a3h4"
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
