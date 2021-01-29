{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "tryorama";
  src = let repo = fetchFromGitHub {
    owner = "Holochain";
    repo = "tryorama";
    rev = "279892e2943685d139dbb1ce2c61584230f3e79b";
    sha256 = "02f15n3ca695rz32ws2yn8k016hiic1353fga1kd1mlys9g15gz4";
  };
  in "${repo}/crates/trycp_server";

  cargoSha256 = "17d6jj0xwzlhjj8ghnd1szy8m4z6ff169zfr90bfck6jw0wxs6ws";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
