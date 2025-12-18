{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/audio.nix
    ../../modules/home.nix
  ];

  networking.hostName = "ste";

  system.stateVersion = "24.11";
}

