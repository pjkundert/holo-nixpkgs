{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "862a1f5e17f7a22b86f9fb2aea396bf4a1ff2ede";
    sha256 = "1q979kcglawh9ba5g6yqkjs2kxzwl76pxygplwlq4mwv0yrzh0qv";
  };

  cargoSha256 = "19f0dy2vwfgs2xjf11zjl3qy1h3mmvq12gdxrys4ds9cpr7rixk0";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
