{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig, lib, callPackage }:

rec {
  mkHolochainBinary = {
        rev
      , sha256
      , cargoSha256
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
    rev = "2c12ea38aaa659e8fb44d8d4d08abf4816491c6f";
    sha256 = "1g44gvldf8mifxkjmxag8zs767nlm2qag8n9l4b95rcjn56injvx";
    cargoSha256 = "0f4vp2j9lm1y82kshyajfbkmzssidin6v85kap3v1hvqf09yvnq0";
    crate = "holochain";
  };
}
