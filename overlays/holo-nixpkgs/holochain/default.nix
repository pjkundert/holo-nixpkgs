{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium }:

rustPlatform.buildRustPackage {
  name = "holochain";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain";
    rev = "4b4521d9b32e7c3aae960e31b5d7fa2c46a424fd";
    sha256 = "0b9ashbnbvwdpw3b4nv9z4yyr3p5wpk0kprra6czdp5iljlssc26";
  };

  cargoSha256 = "0q5gsl0pfhxxq44v4hyq9q5670qinz69g0mbyckwpmzsxz4cz7ny";

  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
