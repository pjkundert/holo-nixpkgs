{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "ddbb1cddc165246ff3fa1871de85dbaa334c95ff";
    sha256 = "1kd5xgypa7nynw19nlvp0k5r5b9f0iqk1j2x77sbnr3d0cdk802f";
  };

  cargoSha256 = "0lngplpk7y530ip5nbn1j3gyk1f10n4si3f33bfwdap8mk8p1ks5";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
