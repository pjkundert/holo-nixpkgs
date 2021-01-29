{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "tryorama";
  src = let repo = fetchFromGitHub {
    owner = "Holochain";
    repo = "tryorama";
    rev = "2e79d6320dab3fbdee75107b862d1138fdb2d8b9";
    sha256 = "1nbad3l57y6k1ib3pxjdmr543254qx1a0iid705m34ap56dyq7ax";
  };
  in "${repo}/crates/trycp_server";

  cargoSha256 = "1kvh9bykw6x5il5xb1sl38152qvzq83ip96pim1xsz80fwbpzbkm";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
