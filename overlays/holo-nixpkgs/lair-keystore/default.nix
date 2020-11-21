{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  name = "lair-keystore";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "lair";
    rev = "a8d4e972c5e674b07f34f8f51eb582266e1ad1db";
    sha256 = "01yx7awai530m1s9vgdsj6b79xqqj30c6z55jvhpaqzl45cmj3aw";
  };

  cargoSha256 = "0zfx8hc55hxa4v86xwx5w7s34y1ayx5czmpa9kdvc870bzwfnwcx";

  doCheck = false;
}
