{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  name = "lair-keystore";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "lair";
    rev = "7718ef2bf1386b7719a12d506b0c50e2240d162b";
    sha256 = "01nvaz718m7r41fs3yyw2l8mswnhn6r3kqy9v6hdw8iinkg0x9qv";
  };

  cargoSha256 = "07mf5r1yw2b2dimha6nskf1qrvyncjb5g97ilm68209h8qj0i1fy";

  doCheck = false;
}
