{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "tryorama";
  src = let repo = fetchFromGitHub {
    owner = "Holochain";
    repo = "tryorama";
    rev = "a93821eae438f64ef683c111dce28fa48bb70370";
    sha256 = "0fczy12h0jz59gxgsk21zr7gcdmvlbd4jl22b7i3j4gy95h304i6";
  };
  in "${repo}/crates/trycp_server";

  cargoSha256 = "17d6jj0xwzlhjj8ghnd1szy8m4z6ff169zfr90bfck6jw0wxs6ws";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
