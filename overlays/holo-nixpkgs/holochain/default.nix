{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "ddda96773b3e97f658ed46f2400ff8d0183be3fd";
    sha256 = "10hdq77klxw50n3yp5zpavwi1kx9ld19lf6vz2m46zk9dm8gl5qq";
  };

  cargoSha256 = "1nyqfcf8y22v1shcniv4pxi3kiqgqqxp2gn3l3wqfw5pnh0ch84r";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
