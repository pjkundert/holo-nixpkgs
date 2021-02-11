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
  name = "holo-envoy";
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-envoy";
    rev = "e8d9ed1c56e15fdbf1dc5d710aafee7d4c07edad";
    sha256 = "1zk0fqdpisc56i4sbdwqx2hr924v0103vvryws4a68fpvcx1aj6j";
  };

  buildInputs = [ python ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    # REVIEW: why do we need this? ask @mjbrisebois
    ps
  ];

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

  checkPhase = ''
      make test-nix
      make stop-sim2h
  '';

  # HACK: consider flipping it on when test timeout issues are resolved
  doCheck = false;
}
