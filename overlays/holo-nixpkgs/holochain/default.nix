{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "d236427516f7df8c1994964b8b8adae59f5002a2";
    sha256 = "19f0dy2vwfgs2xjf11zjl3qy1h3mmvq12gdxrys4ds9cpr7rixk0";
  };

  cargoSha256 = "1q979kcglawh9ba5g6yqkjs2kxzwl76pxygplwlq4mwv0yrzh0qv";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
