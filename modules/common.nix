{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # Timezone configuration
  time.timeZone = "America/Detroit";

  users.users.cnqso = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialPassword = "nixos";
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/cnqso/nix-config"; # sets NH_OS_FLAKE variable for you
  };

  # Basic system packages everyone needs
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    wget
    fastfetch
    alejandra
    nh
  ];
}

