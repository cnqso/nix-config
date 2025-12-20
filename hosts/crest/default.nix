{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/home.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable firmware for Realtek RTL8125 ethernet (2.5GbE)
  hardware.enableRedistributableFirmware = true;
  
  # Use the better out-of-tree Realtek driver for RTL8125
  boot.blacklistedKernelModules = [ "r8169" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.r8125 ];
  boot.kernelModules = [ "r8125" ];

  networking.hostName = "crest";
  networking.networkmanager.enable = true;
  
  # Force specific DNS servers (instead of using router's DNS)
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.niri.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  users.users.cnqso = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialPassword = "nixos"; # CHANGE THIS IMMEDIATELY
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    kitty
    firefox
    xwayland-satellite
    fuzzel
    alacritty
    neovim
    wlr-randr

    code-cursor
    wl-clipboard
  ];

  system.stateVersion = "24.11";
}
