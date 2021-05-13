{ stdenv, rustPlatform, fetchFromGitHub, lib, darwin }:

rustPlatform.buildRustPackage {
  name = "lair-keystore";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "lair";
    rev = "3bd7105108ab241d6719e200dd15905cd3e74da1";
    sha256 = "12sl59sclvf23p8qnql1f08xdmv08yy4pgrg94hfgw526g0z7vvw";
  };

  cargoSha256 = "1x7gzndv8qax3wwv7imki9rrzm0l22qhf49bdkjjn6nb430fmlnk";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
  ]);

  doCheck = false;
}
