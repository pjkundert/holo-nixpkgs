{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

{
  self-hosted-happs-node = stdenv.mkDerivation rec {
    name = "self-hosted-happs-node";
    src = fetchFromGitHub {
      owner = "holo-host";
      repo = "self-hosted-happs-node";
      rev = "f136fdd0d7a033d99c3f59033daa77062ede991a";
      sha256 = "1pv9vcnqwbczk918mh334lz03pq1g6dvlypsl6870csrbygvmzgl";
    };

    buildInputs = [ nodejs ];

    preConfigure = ''
      cp -r ${npmToNix { src = "${src}/"; }} node_modules
      chmod -R +w node_modules
      chmod +x node_modules/.bin/webpack
      patchShebangs node_modules
    '';

    buildPhase = ''
      npm run build
    '';

    installPhase = ''
      cp -r dist/ $out
    '';

    doCheck = false;
    meta.platforms = stdenv.lib.platforms.linux;
  };
}
