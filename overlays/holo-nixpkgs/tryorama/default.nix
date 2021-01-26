{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "tryorama";
  src = let repo = fetchFromGitHub {
    owner = "Holochain";
    repo = "tryorama";
    rev = "8eec9e2839817dc14792d1da28f9854d8965992b";
    sha256 = "014a23jlw721npfy0cil87absyh1g1wkc5wczr2ay30xx6ycz80d";
  };
  in "${repo}/crates/trycp_server";

  cargoSha256 = "0b1mqdldv0vqdbv805mv222399qv823fmpjlh2kzqams2aq3xgbh";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
