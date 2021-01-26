{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig, lib, callPackage }:

rec {
  mkHolochainBinary = {
        version ? "2020-12-17"
      , rev ? "b3c0659bee5bc744123140dbbb111e74deace3f0"
      , sha256 ? "1g1mzasn1lsw5kbyvim93k157aac37lq92v1zxkvcflyb16v3wf2"
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
