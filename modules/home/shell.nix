{ pkgs, lib, ... }:

{
  home-manager.users.cnqso = { config, ... }: {
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
        stopcontainers = "sudo docker stop $(sudo docker ps -q)";
        nginxconf = "sudo nvim /etc/nginx/nginx.conf";
        serverdb = "harlequin /home/cnqso/code/server/go/db/db.db";
        music = "cd /mnt/sdb/Media/Soulseek";
        servup = "cd ~/code/server/go && go run .";

        # NixOS rebuild aliases (dynamically use current hostname)
        nr = "sudo nixos-rebuild switch --flake $HOME/nix-config#$(hostname)";
        nrb = "sudo nixos-rebuild build --flake $HOME/nix-config#$(hostname)";
        nrt = "sudo nixos-rebuild test --flake $HOME/nix-config#$(hostname)";
        nfc = "cd $HOME/nix-config && sudo nix flake check";
        nfu = "cd $HOME/nix-config && sudo nix flake update";
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
  };
}
