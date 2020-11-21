{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

{
  self-hosted-happs-node = stdenv.mkDerivation rec {
    name = "self-hosted-happs-node";
    src = fetchFromGitHub {
      owner = "holo-host";
      repo = "self-hosted-happs-node";
      rev = "4b1a3725fb2d0f3b6b66b0980589d63584872e6f";
      sha256 = "102prnw57fjw5rnafn5az6cw90ywlqk86gpbkwfxziji2q7xsla3";
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
