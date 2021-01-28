{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "tryorama";
  src = let repo = fetchFromGitHub {
    owner = "Holochain";
    repo = "tryorama";
    rev = "7f94a4c60981c555a3ac1e16739ae3958672e1de";
    sha256 = "06204nk7f3mjrnysz05ax1d08c24m6kn0a2zww5q6zzc2hfgmy96";
  };
  in "${repo}/crates/trycp_server";

  cargoSha256 = "17d6jj0xwzlhjj8ghnd1szy8m4z6ff169zfr90bfck6jw0wxs6ws";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
