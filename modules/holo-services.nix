{ stdenv, lib, config, fetchurl, ... }:

let
  conductor-config = stdenv.mkDerivation {
    name = "conductor-fonfig";
    src = fetchurl {
      url = https://gist.githubusercontent.com/samrose/caba3e3556e11151bdc90f0b0fb567a9/raw/a46de503498dbe1bbed275168e3a6db459f235f0/empty-container.toml;
      sha256 = "1g8m78qzdnbp3vp8sd5qlpa2p1r5fmav28yjsrf65k4wfkn62dr4";
    };
  }

in

  systemd.services.conductor = {
    path = [pkgs.bash];
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/holochain -c ${conductor-config}";
    };
    wantedBy = [ "default.target" ];
  };
