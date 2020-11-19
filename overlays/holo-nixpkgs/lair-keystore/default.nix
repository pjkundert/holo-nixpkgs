{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  name = "lair-keystore";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "lair";
    rev = "c342d29fa9928f65790e606fa109e6cca7caa457";
    sha256 = "054qfpxi3lszmvhcg385c6yipma9fmysq6z9spp4c6lzin8y0ncs";
  };

  cargoSha256 = "0bjqgp4z4cbq8hj9z0m0xy6dlhjxvfx5gclk24fcdg0k2ilbvj93";

  doCheck = false;
}
