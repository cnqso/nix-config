{ pkgs, lib, ... }:

{
  # Configure Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.cnqso = { config, osConfig, ... }: {
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

      # NOTE: Home Manager niri config removed for now (it was failing evaluation because
      # Home Manager doesn't provide a `programs.niri` module / `lib.niri` helpers here).
      xdg.configFile = lib.mkIf (osConfig.networking.hostName == "crest") {
        "niri/config.kdl" = {
          force = true;
          text = ''
            output "HDMI-A-2" {
                mode "2560x1440@59.951"
                position x=0 y=0
            }

            output "DP-1" {
                mode "2560x1440@143.912"
                position x=2560 y=0
                focus-at-startup
            }
          '';
        };
      };

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
