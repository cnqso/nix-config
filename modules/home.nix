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
    # Make portal backend selection explicit.
    # On wlroots compositors, the wlr backend is great for screencast/screenshot,
    # but the GTK backend is the one that implements the file chooser Firefox uses
    # when `widget.use-xdg-desktop-portal.file-picker` is enabled.
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



  # Desktop applications and tools
  environment.systemPackages = with pkgs; [
    
    kitty
    alacritty


    firefox


    qbittorrent


    vlc

    ranger


    xwayland-satellite
    fuzzel
    wlr-randr
    wl-clipboard
    prismlauncher


    code-cursor
    claude-code

    dolphin-emu
  ];

  # Configure Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.cnqso = { config, osConfig, ... }: {
      home.stateVersion = "24.11";

      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        playerctl
        brightnessctl
        telegram-desktop
      ];

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

      programs.bash = {
        enable = true;
        shellAliases = {
          ls = "ls --color=auto";
          headphones = "bluetoothctl connect 4C:87:5D:50:87:6C";
          keyboard = "bluetoothctl connect DC:2C:26:EF:B8:13";
          conf = "cd ~/.config";
          drive1 = "cd /mnt/sda";
          drive2 = "cd /mnt/sdb";
          grep = "grep --color=auto";
          f = "fastfetch";
          r = "pulseaudio -k & disown";
          resync = "pulseaudio -k & disown";
          zelda = "cd /home/cnqso/Desktop/Harkinian && ./soh.appimage";
          dock = "sudo docker compose up --build";
          zed = "env -u WAYLAND_DISPLAY zeditor & exit";
          record = "gpu-screen-recorder -w screen -o ~/Videos/screen-record-$(date +%Y%m%d-%H%M%S).mp4";
          stopcontainers = "sudo docker stop $(sudo docker ps -q)";
          nginxconf = "sudo nvim /etc/nginx/nginx.conf";
          serverdb = "harlequin /home/cnqso/code/server/go/db/db.db";
          music = "cd /mnt/sdb/Media/Soulseek";
          servup = "cd ~/code/server/go && go run .";

          # NixOS rebuild aliases (dynamically use current hostname)
          nr = "sudo nixos-rebuild switch --flake $HOME/nix-config#$(hostname)";
          nrb = "sudo nixos-rebuild build --flake $HOME/nix-config#$(hostname)";
          nrt = "sudo nixos-rebuild test --flake $HOME/nix-config#$(hostname)";
          nfc = "cd $HOME/nix-config && nix flake check";
          nfu = "cd $HOME/nix-config && nix flake update";
        };
        
        sessionVariables = {
          PATH = "$HOME/.dotfiles/bin:$HOME/.local/bin:$PATH";
        };
        
        initExtra = ''
          # Custom prompt with powerline style and lambda
          set_prompt() {
            # Capture exit status of last command
            local EXIT_STATUS="$?"
            
            # Top line with user, host, date, time
            local TOP_LINE="\[\e[41;30m\] 󱄅 \[\e[42;31m\]\[\e[42;30m\] \u \[\e[46;32m\]\[\e[46;30m\] \h \[\e[45;36m\]\[\e[45;30m\] \t \[\e[0m\]"
            
            # Bottom line with lambda and working directory
            local LAMBDA="󱄅"
            if [ $EXIT_STATUS -eq 0 ]; then
              LAMBDA="\[\e[32m\]$LAMBDA\[\e[0m\]"
            else
              LAMBDA="\[\e[31m\]$LAMBDA\[\e[0m\]"
            fi
            
            local BOTTOM_LINE="\n$LAMBDA "
            PS1="$TOP_LINE$BOTTOM_LINE"
          }
          
          PROMPT_COMMAND='set_prompt'
          
          # Don't do anything if not running interactively
          [[ $- != *i* ]] && return
        '';
      };

      programs.niri.settings = {

        prefer-no-csd = true;

        # Always start Waybar alongside Niri.
        # Host configs can append more entries with `lib.mkAfter`.
        spawn-at-startup = [
          { command = [ "waybar" ]; }
        ];
        
        # Default keybinds
        binds = {

          "Mod+T".action.spawn = ["kitty"];
          "Mod+Space".action.spawn = ["fuzzel"];
          
          "Mod+Q".action.close-window = {};
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+J".action.focus-window-down = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+Left".action.focus-column-left = {};
          "Mod+Right".action.focus-column-right = {};
          
          
          "Mod+Home".action.focus-column-first = {};
          "Mod+End".action.focus-column-last = {};
          "Mod+Ctrl+Home".action.move-column-to-first = {};
          "Mod+Ctrl+End".action.move-column-to-last = {};
          
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+Left".action.move-column-left = {};
          "Mod+Shift+Right".action.move-column-right = {};

          "Mod+Page_Down".action.focus-workspace-down = {};
          "Mod+Page_Up".action.focus-workspace-up = {};
          "Mod+Up".action.focus-workspace-up = {};
          "Mod+Down".action.focus-workspace-down = {};
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
          "Mod+Ctrl+U".action.move-column-to-workspace-up = {};
          "Mod+Ctrl+I".action.move-column-to-workspace-down = {};

          "Mod+Shift+Page_Down".action.move-workspace-down = {};
          "Mod+Shift+Page_Up".action.move-workspace-up = {};
          "Mod+Shift+Up".action.move-workspace-up = {};
          "Mod+Shift+Down".action.move-workspace-down = {};
          
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;

          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;
          
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;
          "Mod+Shift+6".action.move-window-to-workspace = 6;
          "Mod+Shift+7".action.move-window-to-workspace = 7;
          "Mod+Shift+8".action.move-window-to-workspace = 8;
          "Mod+Shift+9".action.move-window-to-workspace = 9;

          "Mod+Comma".action.consume-window-into-column = {};
          "Mod+Period".action.expel-window-from-column = {};
          
          "Mod+R".action.switch-preset-column-width = {};
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = {};
          "Mod+C".action.center-column = {};
          
          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};

          "Mod+Ctrl+Right".action.focus-monitor-right = {};
          "Mod+Ctrl+Left".action.focus-monitor-left = {};
          
          "Print".action.screenshot = {};
          "Ctrl+Print".action.screenshot-screen = {};
          "Alt+Print".action.screenshot-window = {};
          
          "Mod+Shift+E".action.quit = {};
          "Mod+Shift+P".action.power-off-monitors = {};

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-column-width = "-10%";
          "Mod+Shift+Equal".action.set-column-width = "+10%";
          
          "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
          "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
          "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];

          "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
          "XF86AudioPause".action.spawn = ["playerctl" "play-pause"];
          
          "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "10%+"];
          "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "10%-"];
          
          "XF86KbdBrightnessUp".action.spawn = ["brightnessctl" "--device=*kbd_backlight" "set" "10%+"];
          "XF86KbdBrightnessDown".action.spawn = ["brightnessctl" "--device=*kbd_backlight" "set" "10%-"];

          "Mod+Shift+Slash".action.show-hotkey-overlay = {};



          
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

      programs.kitty = {
        enable = true;
        settings = {
          enable_audio_bell = false;
          window_padding_width = 8;
          confirm_os_window_close = 0;
        };
      };
    };
  };
}
