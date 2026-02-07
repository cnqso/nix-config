{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/media.nix
    ../../modules/dev.nix
    ../../modules/stylix.nix
    ../../modules/waybar.nix
    ../../modules/home
  ];

  networking.hostName = "ste";

  system.stateVersion = "24.11";
}
