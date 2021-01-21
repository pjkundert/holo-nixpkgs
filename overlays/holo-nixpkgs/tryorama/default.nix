{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "tryorama";
  src = let repo = fetchFromGitHub {
    owner = "Holochain";
    repo = "tryorama";
    rev = "d16ffef5cdf98f1a7af34f7f0a3752d536e8e533";
    sha256 = "1yzvsmn2m2382ym8ij1lbn0x3ahb5mai71hssxgrx4f52ic63q4f";
  };
  in "${repo}/crates/trycp_server";
  
  cargoSha256 = "1w5bzixhn6rfkg20fv9lns2c0xibd2jnbk8dgl1mxddmf3nq3gw3";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
