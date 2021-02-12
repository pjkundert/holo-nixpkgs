{ stdenv, rustPlatform, fetchFromGitHub, perl, xcbuild, darwin, libsodium, openssl, pkgconfig, lib, callPackage }:

rec {
  mkHolochainBinary = {
      version ? "2021-02-02"
      , rev ? "ba2d507912626bdefca8df6cf36cf7de66651bf5"
      , sha256 ? "1745xjqp98cq7yf00yf5l1kdxdjzqkb8chxkjpxzhryz46qgn6iq"
      , cargoSha256 ? "1ja1h1717jvvgmxghy4al9qbn5kk007914cislp7gzbn1x2kzbz7"
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

    nativeBuildInputs = [ perl pkgconfig ] ++ stdenv.lib.optionals stdenv.isDarwin [
      xcbuild
    ];

    buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AppKit
      CoreFoundation
      CoreServices
      Security
    ]);

    RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
    RUST_SODIUM_SHARED = "1";

    doCheck = false;
    meta.platforms = [
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
    ];
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
