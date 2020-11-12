{ stdenv
, rustPlatform
, fetchFromGitHub
, makeWrapper
, nodejs
, npmToNix
, ps
, python
, fetchgit
}:

stdenv.mkDerivation rec {
  name = "host-console-server";

  buildInputs = [ python ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  buildCommand = ''
    makeWrapper ${python3}/bin/python3 $out/bin/${name} \
      --add-flags ${./hpos-admin.py} \
      --prefix PATH : ${makeBinPath [ hpos-config-is-valid zerotierone hpos-reset ]}
  '';

  preConfigure = ''
    cp -r ${npmToNix { inherit src; }} node_modules
    chmod -R +w node_modules
    patchShebangs node_modules
  '';

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
      mkdir $out
      mv build node_modules rpc-websocket-wrappers server.js $out
      makeWrapper ${nodejs}/bin/node $out/bin/${name} \
        --add-flags $out/server.js
  '';

  fixupPhase = ''
    patchShebangs $out
  '';

  # HACK: consider flipping it on when test timeout issues are resolved
  doCheck = false;
}








{ stdenv, makeWrapper, python3, hpos-config-is-valid, zerotierone, hpos-reset }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "host-console-server";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  buildCommand = ''
    makeWrapper ${python3}/bin/python3 $out/bin/${name} \
      --add-flags ${./hpos-admin.py} \
      --prefix PATH : ${makeBinPath [ hpos-config-is-valid zerotierone hpos-reset ]}
  '';

  meta.platforms = platforms.linux;
}
