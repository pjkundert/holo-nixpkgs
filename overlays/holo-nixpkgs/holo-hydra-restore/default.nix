{ stdenv, fetchFromGitHub, makeWrapper, openssl, restic }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "holo-hydra-restore";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hydra-create";
    rev = "4c911b49339f4e2390ae461bc5e1def0cea0b243";
    sha256 = "13wspybqw4fkslfhm4zh7zwc7g6w9kynwzrss42in0wgjvh2rc6n";
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