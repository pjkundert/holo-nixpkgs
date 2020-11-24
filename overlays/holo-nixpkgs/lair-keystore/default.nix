{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  name = "lair-keystore";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "lair";
    rev = "7b5f886dd7c9060175f20c05f80d0a298cce34f0";
    sha256 = "1rigd5q69pgbh7rfzfsaxba83x0g1amrj6yy3xf66kgly8mxzhl8";
  };

  cargoSha256 = "1c2380251nzhzs7cd6mgrjpyh52614i7ca01c5kl6cgqz41k80ii";

  doCheck = false;
}
