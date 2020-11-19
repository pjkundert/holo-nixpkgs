{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

{
  self-hosted-happs-node = stdenv.mkDerivation rec {
    name = "self-hosted-happs-node";
    src = fetchFromGitHub {
      owner = "holo-host";
      repo = "self-hosted-happs-node";
      rev = "7efc5d1101f223d8239bbc96899d1f6fa3362e3d";
      sha256 = "1wvmamapcszfvidw5hgxbg8mij2ds8sbzhfahjysg57jc9hd9il8";
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
