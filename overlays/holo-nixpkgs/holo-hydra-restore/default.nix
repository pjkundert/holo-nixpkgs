{ lib, stdenv, fetchFromGitHub, openssl, restic }:

stdenv.mkDerivation rec {
  name = "holo-hydra-restore";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hydra-create";
    rev = "cdc69008ff895fcfebf992a80c49efccc5bb476b";
    sha256 = "0ir0pahm73j6gcaz4df2h2gwyy0ik1xji83qpqrir18ishla224r";
  };

  buildInputs = [ openssl restic ];

  installPhase = ''
    install -Dm +x holo-hydra-restore $out/bin/holo-hydra-restore
  '';

  meta.platforms = lib.platforms.linux;
  doCheck = false;
}