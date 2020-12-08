{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium, openssl, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "2c12ea38aaa659e8fb44d8d4d08abf4816491c6f";
    sha256 = "1g44gvldf8mifxkjmxag8zs767nlm2qag8n9l4b95rcjn56injvx";
  };

  cargoSha256 = "1jpkvcdwcrijzka1jjlkwy1xxsr0p9c2w3ja42vkvxk3xzp9wz8s";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
