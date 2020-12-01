{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "9c33fb7fb709d189b56359dcc7b330f1982b6ae6";
    sha256 = "0d8wzvswi7syxrb1q20z417gdg9y5sgl25yvmb0k3izs032s0w13";
  };

  cargoSha256 = "1jrd15a7y85iniy2mxacaniwzbbh5ncqpq70kkc6fp1zpgrnmq65";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}