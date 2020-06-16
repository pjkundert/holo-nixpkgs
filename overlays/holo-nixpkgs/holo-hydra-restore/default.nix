{ lib, stdenv, fetchFromGitHub, openssl, restic }:

stdenv.mkDerivation rec {
  name = "holo-hydra-restore";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hydra-create";
    rev = "0fdfee326203168eaf21141cbdc4899a5e979327";
    sha256 = "0haly8mbhfhbswwg6x1q94dmz9gnwf7g90qpwhza169zcn422dbj";
  };

  buildInputs = [ openssl restic ];

  installPhase = ''
    install -Dm +x holo-hydra-restore $out/bin/holo-hydra-restore
  '';

  meta.platforms = lib.platforms.linux;
  doCheck = false;
}