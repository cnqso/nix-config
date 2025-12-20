{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/audio.nix
    ../../modules/home.nix
    ../../modules/stylix.nix
    ../../modules/waybar.nix
  ];

  networking.hostName = "ste";

  system.stateVersion = "24.11";
}

