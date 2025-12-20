{ pkgs, lib, inputs, ... }:

{
  # Configure Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.cnqso = { config, osConfig, ... }: {
      imports = [
        inputs.stylix.homeModules.stylix
      ];
      
      home.stateVersion = "24.11";

      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
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
            local LAMBDA="󰡣"
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


      # Niri settings (crest-specific monitor layout)
      programs.niri.settings = lib.mkIf (osConfig.networking.hostName == "crest") {
        outputs = {
          "HDMI-A-2" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 59.951;
            };
            position = {
              x = 0;
              y = 0;
            };
          };
          "DP-1" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 143.912;
            };
            position = {
              x = 2560;
              y = 0;
            };
          };
        };
        
        prefer-no-csd = true;
        
        # Default keybinds
        binds = {
          # Launchers
          "Mod+T".action.spawn = ["kitty"];
          "Mod+D".action.spawn = ["fuzzel"];
          "Mod+Return".action.spawn = ["kitty"];
          
          # Window management
          "Mod+Q".action.close-window = {};
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+J".action.focus-window-down = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+Left".action.focus-column-left = {};
          "Mod+Right".action.focus-column-right = {};
          "Mod+Down".action.focus-window-down = {};
          "Mod+Up".action.focus-window-up = {};
          
          # Moving windows
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+Left".action.move-column-left = {};
          "Mod+Shift+Right".action.move-column-right = {};
          "Mod+Shift+Down".action.move-window-down = {};
          "Mod+Shift+Up".action.move-window-up = {};
          
          # Workspaces
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          
          # Move to workspace
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;
          "Mod+Shift+6".action.move-window-to-workspace = 6;
          "Mod+Shift+7".action.move-window-to-workspace = 7;
          "Mod+Shift+8".action.move-window-to-workspace = 8;
          "Mod+Shift+9".action.move-window-to-workspace = 9;
          
          # Window sizing
          "Mod+R".action.switch-preset-column-width = {};
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = {};
          "Mod+C".action.center-column = {};
          
          # Monitor navigation
          "Mod+Shift+Ctrl+Left".action.move-column-to-output-left = {};
          "Mod+Shift+Ctrl+Right".action.move-column-to-output-right = {};
          "Mod+Shift+Ctrl+H".action.move-column-to-output-left = {};
          "Mod+Shift+Ctrl+L".action.move-column-to-output-right = {};
          
          # Screenshots
          "Print".action.screenshot = {};
          "Ctrl+Print".action.screenshot-screen = {};
          "Alt+Print".action.screenshot-window = {};
          
          # System
          "Mod+Shift+E".action.quit = {};
          "Mod+Shift+P".action.power-off-monitors = {};
          
          # Media keys
          "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
          "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
          "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        };
      };

      # Enable stylix for niri theming
      stylix.targets.niri.enable = true;


      # Kitty terminal configuration (simple rice)
      programs.kitty = {
        enable = true;
        # Apply theme explicitly. This avoids HM's kitty theme activation check trying to
        # reinterpret the value (which can lead to doubled paths / `.conf.conf`).
        extraConfig = ''
          include ${pkgs.kitty-themes}/share/kitty-themes/themes/gruvbox-light.conf
        '';
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
