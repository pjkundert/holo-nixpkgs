{ stdenv, rustPlatform, fetchFromGitHub, lib, darwin }:

rustPlatform.buildRustPackage {
  name = "lair-keystore";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "lair";
    rev = "a01a40640574d3cfabae33dfe3f861de7bd7a57c";
    sha256 = "0n5rsmpfw24g4pcgrqqxqk8fwhyky7mm3nf39vyrpk3xyxh3addr";
  };

  cargoSha256 = "09g7p9yjz9gd203zpvd2cijxg6adciydr521c4zbfl47zm1x43f6";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
  ]);

  doCheck = false;
}
