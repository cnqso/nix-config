{ pkgs, ... }:

{
  stylix = {
    enable = true;

    # Rose Pine Dawn color scheme (light theme)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.source-serif;
        name = "Source Serif 4";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };

    # Cursor configuration
    cursor = {
      package = pkgs.simp1e-cursors;
      name = "Simp1e";
      size = 24;
    };

    # Opacity settings
    opacity = {
      terminal = 0.95;
      applications = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    # Polarity (light theme)
    polarity = "light";

    # Target applications (system-level)
    targets = {
      console.enable = true;
      grub.enable = false;  # Not using GRUB
    };
  };
}
