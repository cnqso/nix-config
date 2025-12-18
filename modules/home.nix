{ pkgs, ... }:

{
  # Configure Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.cnqso = { config, ... }: {
      home.stateVersion = "24.11";

      home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      programs.git = {
        enable = true;
        userName = "cnqso";
        userEmail = "wmkelly@umich.edu";
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = false;
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
            local TOP_LINE="\[\e[41;30m\] 󰣇 \[\e[42;31m\]\[\e[42;30m\] \u \[\e[46;32m\]\[\e[46;30m\] \h \[\e[45;36m\]\[\e[45;30m\] \t \[\e[0m\]"
            
            # Bottom line with lambda and working directory
            local LAMBDA="λ"
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

      # Niri window manager configuration
      programs.niri = {
        settings = {
          # Input configuration
          input = {
            keyboard.xkb.layout = "us";
            touchpad = {
              tap = true;
              natural-scroll = true;
            };
            focus-follows-mouse = {
              enable = true;
              max-scroll-amount = "10%";
            };
          };

          # Layout configuration
          layout = {
            gaps = 8;
            center-focused-column = "on-overflow";
            preset-column-widths = [
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];
            default-column-width = { proportion = 0.5; };
            focus-ring = {
              enable = true;
              width = 2;
              active.color = "#7aa2f7";      # Tokyo Night blue
              inactive.color = "#414868";    # Tokyo Night dark gray
            };
            border = {
              enable = true;
              width = 1;
              active.color = "#7aa2f7";
              inactive.color = "#24283b";
            };
          };

          # Spawn programs at startup
          spawn-at-startup = [
            { command = ["firefox"]; }
          ];

          # Prefer no borders when only one window
          prefer-no-csd = true;

          # Screenshot setup
          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          # Window rules for specific apps
          window-rules = [
            {
              matches = [{ app-id = "firefox"; }];
              default-column-width = { proportion = 0.66667; };
            }
            {
              matches = [{ app-id = "kitty"; }];
              default-column-width = { proportion = 0.5; };
            }
          ];

          # Keybindings
          binds = with config.lib.niri.actions; {
            # Basics
            "Mod+Return".action = spawn "kitty";
            "Mod+D".action = spawn "fuzzel";
            "Mod+Q".action = close-window;

            # Movement
            "Mod+H".action = focus-column-left;
            "Mod+L".action = focus-column-right;
            "Mod+J".action = focus-window-down;
            "Mod+K".action = focus-window-up;

            # Moving windows
            "Mod+Shift+H".action = move-column-left;
            "Mod+Shift+L".action = move-column-right;
            "Mod+Shift+J".action = move-window-down;
            "Mod+Shift+K".action = move-window-up;

            # Workspaces (1-9)
            "Mod+1".action = focus-workspace 1;
            "Mod+2".action = focus-workspace 2;
            "Mod+3".action = focus-workspace 3;
            "Mod+4".action = focus-workspace 4;
            "Mod+5".action = focus-workspace 5;
            "Mod+6".action = focus-workspace 6;
            "Mod+7".action = focus-workspace 7;
            "Mod+8".action = focus-workspace 8;
            "Mod+9".action = focus-workspace 9;

            # Move to workspace
            "Mod+Shift+1".action = move-column-to-workspace 1;
            "Mod+Shift+2".action = move-column-to-workspace 2;
            "Mod+Shift+3".action = move-column-to-workspace 3;
            "Mod+Shift+4".action = move-column-to-workspace 4;
            "Mod+Shift+5".action = move-column-to-workspace 5;
            "Mod+Shift+6".action = move-column-to-workspace 6;
            "Mod+Shift+7".action = move-column-to-workspace 7;
            "Mod+Shift+8".action = move-column-to-workspace 8;
            "Mod+Shift+9".action = move-column-to-workspace 9;

            # Resize
            "Mod+R".action = switch-preset-column-width;
            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;

            # Screenshots
            "Print".action = screenshot;
            "Shift+Print".action = screenshot-window;

            # Exit/reload
            "Mod+Shift+E".action = quit;
            "Mod+Shift+R".action = spawn "pkill" "-USR1" "niri";
          };
        };
      };

      # Kitty terminal configuration (simple rice)
      programs.kitty = {
        enable = true;
        theme = "Tokyo Night";
        settings = {
          font_family = "JetBrainsMono Nerd Font";
          font_size = 12;
          enable_audio_bell = false;
          window_padding_width = 8;
          background_opacity = "0.95";
          confirm_os_window_close = 0;
        };
      };
    };
  };
}
