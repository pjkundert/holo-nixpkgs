{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

{
  self-hosted-happs-node = stdenv.mkDerivation rec {
    name = "self-hosted-happs-node";
    src = fetchFromGitHub {
      owner = "holo-host";
      repo = "self-hosted-happs-node";
      rev = "60530dc846df1d9c94352247547cb11d38244960";
      sha256 = "1fm6bmcdn27d1lnww88w4a5wmxiwkqvk7c1vqq6fwx864wq5rrhd";
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
