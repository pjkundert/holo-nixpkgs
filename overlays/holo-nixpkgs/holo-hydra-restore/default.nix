{ stdenv, fetchFromGitHub, makeWrapper, openssl, restic }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "holo-hydra-restore";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hydra-create";
    rev = "0fdfee326203168eaf21141cbdc4899a5e979327";
    sha256 = "0haly8mbhfhbswwg6x1q94dmz9gnwf7g90qpwhza169zcn422dbj";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm +x holo-hydra-restore $out/bin/${name}
    wrapProgram $out/bin/${name} \
      --prefix PATH : ${makeBinPath [ openssl restic ]}
  '';

  meta.platforms = platforms.linux;
  doCheck = false;
}