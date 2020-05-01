let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/2847777ec7e8be68ebafb30cd4c3dcd721208f99.tar.gz";
    sha256 = "14bv9i0swbw04k4fwbb34dzf7yyd6ax79kr3xzrmj475a694fkz4";
  };

  inherit (import nixpkgs {}) stdenvNoCC fetchpatch;
in

stdenvNoCC.mkDerivation {
  name = "nixpkgs";
  src = nixpkgs;

  patches = [ ./virtualbox-image-no-audio-mouse-usb.diff ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  installPhase = ''
    mv $PWD $out
  '';
}
