# Branch Information

This branch is specifically set up for building HoloportOS installation images from source. It is not intended to be a standalone branch

#### HoloPort Nano SD Image

On an Aarch64 machine, run:
`nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./profiles/holoportos-installers/holoport-nano/default.nix`.

Burn the image to a microSD card with `sudo dd if=result/sd-image/*.img
/dev/sdX` (see `lsblk` on Linux and `diskutil list` on macOS for the exact
device name).

Connect Ethernet cable to HoloPort Nano, insert the microSD card, and boot.

During installation, LED will blink with yellow color.

Once LED turns green, installation is complete: eject the microSD card and
reboot.

If LED starts to blink with red, there was an error during installation.
Connect over HDMI to see what's going on. To retry, reboot or type
`holoportos-install` in console.


