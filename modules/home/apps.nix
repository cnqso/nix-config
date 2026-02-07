{ pkgs, lib, ... }:

{
  home-manager.users.cnqso = { config, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "cnqso";
          email = "wmkelly@umich.edu";
        };
        init.defaultBranch = "main";
        pull.rebase = false;
        credential.helper = "store";
      };
    };

    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        isDefault = true;
        extensions.force = true;
        settings = {
          # Always use XDG portals for file picking under Wayland.
          "widget.use-xdg-desktop-portal.file-picker" = 1;

          # Allow userChrome/userContent (Stylix uses this).
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };

    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        window_padding_width = 8;
        confirm_os_window_close = 0;
      };
    };

    # Enable stylix targets for various applications
    stylix.targets = {
      niri.enable = true;
      kitty.enable = true;
      waybar.enable = false;
      gtk.enable = true;
      fzf.enable = true;
      bat.enable = true;
      fuzzel.enable = true;
      fuzzel.colors.enable = true;
      firefox = {
        enable = true;
        colors.enable = true;
        colorTheme.enable = true;
        profileNames = [ "default" ];
      };
      btop = {
        enable = true;
        colors.enable = true;
      };
    };
  };
}
