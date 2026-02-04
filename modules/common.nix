{ pkgs, lib, ... }:

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
  # NOTE: nixpkgs config (allowUnfree / permittedInsecurePackages / allowInsecurePredicate)
  # is set when importing pkgs in `flake.nix` (since `pkgs = ...` is passed to nixosSystem).

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
    gnumake
    socat
    whois
    fastfetch
    alejandra
    nh
    btop
  ];

  # SSH server
  services.openssh = {
    enable = true;
    openFirewall = true; # allow TCP/22 through the host firewall
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}

