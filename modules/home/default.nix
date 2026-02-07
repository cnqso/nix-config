{ pkgs, lib, inputs, ... }:

{
  imports = [
    ./shell.nix
    ./niri.nix
    ./apps.nix
    ./ranger.nix
    ./fastfetch.nix
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

        # Linux BSP Case Folding Workaround helper + deps (Source 1 missing textures fix)
        curl
        inotify-tools
        libnotify
        parallel
        rsync
        unzip
        git
        (writeShellScriptBin "lbspcfw" ''
          set -euo pipefail

          REPO_URL="https://github.com/scorpius2k1/linux-bsp-casefolding-workaround.git"
          BASE_DIR="$(printenv XDG_DATA_HOME 2>/dev/null || true)"
          if [[ -z "$BASE_DIR" ]]; then
            BASE_DIR="$HOME/.local/share"
          fi
          REPO_DIR="$BASE_DIR/linux-bsp-casefolding-workaround"

          if [[ ! -d "$REPO_DIR/.git" ]]; then
            mkdir -p "$(dirname "$REPO_DIR")"
            git clone --depth 1 "$REPO_URL" "$REPO_DIR"
          else
            git -C "$REPO_DIR" pull --ff-only || true
          fi

          chmod +x "$REPO_DIR/lbspcfw.sh"
          exec "$REPO_DIR/lbspcfw.sh" "$@"
        '')
      ];
    };
  };
}
