{ stdenv,  nodejs, npmToNix, fetchFromGitHub }:

{
  hc-state-node = stdenv.mkDerivation rec {
    name = "hc-state-node";

    src = fetchFromGitHub {
      owner = "Holochain";
      repo = "hc-state-cli-node";
      rev = "ffee6a4fe45c4eacd5ebe7c95f18a75331b4a093";
      sha256 = "07z02wkg6qpi06qm4dlh6m2d84g35dphpvhbbr6vr1p6kbxzrv8l";
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
