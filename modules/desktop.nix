{ pkgs, ... }:

{
  programs.niri.enable = true;

  # Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Desktop applications and tools
  environment.systemPackages = with pkgs; [
    # Terminals
    kitty
    alacritty
    
    # Browser
    firefox
    
    # Wayland utilities
    xwayland-satellite
    fuzzel
    wlr-randr
    wl-clipboard
    
    # Development
    code-cursor
    claude-code
  ];
}

