{ pkgs, lib, inputs, ... }:

{
  # Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  # XDG Desktop Portal (needed for Wayland screen sharing + nicer file pickers)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      "org.freedesktop.impl.portal.FileChooser" = {
        default = [ "gtk" ];
      };
      "org.freedesktop.impl.portal.ScreenCast" = {
        default = [ "wlr" ];
      };
      "org.freedesktop.impl.portal.Screenshot" = {
        default = [ "wlr" ];
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.niri.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Desktop applications and tools
  environment.systemPackages = with pkgs; [
    # Terminal emulators
    kitty
    alacritty

    # Browsers
    firefox

    # Media
    qbittorrent
    vlc

    # File manager
    ranger

    # Games
    renpy
    prismlauncher
    dolphin-emu

    # Wayland utilities
    xwayland-satellite
    fuzzel
    wlr-randr
    wl-clipboard

    # Screenshot and recording tools
    grim        # Screenshot tool
    slurp       # Region selection
    wf-recorder # Screen recording

    # Development tools
    code-cursor
    claude-code
    xpipe
  ];
}
