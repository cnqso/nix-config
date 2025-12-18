{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
  ];

  networking.hostName = "ste";

  system.stateVersion = "24.11";
}

