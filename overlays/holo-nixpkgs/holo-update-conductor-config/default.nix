{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  name = "holo-update-conductor-config";
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-update-conductor-config";
    rev = "47c1b20013086064fdd9c7785885fefee3d009f6";
    sha256 = "08yijh7gr8mrvf3da76q9rzwqgmql8zx40cha1mnf7csj6m3g40x";
  };
  cargoSha256 = "18zvspz31lsxfk2627a3zvh83sw7j1sak1glw6bblraljg4s15l3";

  meta.platforms = lib.platforms.linux;
  doCheck = false;
}
