{ pkgs, rustPlatform  }:

with pkgs;

rustPlatform.buildRustPackage {
  name = "hpos-configure-holochain";
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "hpos-configure-holochain";
    rev = "cade6a3c0638a7dac0634298e64ebb5ec6ade70e";
    sha256 = "0zsq0b3r8241mx16npc0rqwvcanh4n9s62r5rv2d6wmdkk1h6faf";
  };

  cargoSha256 = "0cjx904pwa9vczr2gvp1ifshl1vkq4fxc0r9djl2mjzi8x4aa8ak";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta.platforms = lib.platforms.linux;
}
