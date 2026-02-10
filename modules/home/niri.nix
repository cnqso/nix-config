{ pkgs, lib, ... }:

let
  # Screenshot script - area selection, saves to file and clipboard
  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    set -euo pipefail

    SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$SCREENSHOT_DIR"

    FILENAME="screenshot-$(date +%Y%m%d-%H%M%S).png"
    FILEPATH="$SCREENSHOT_DIR/$FILENAME"

    # Area selection screenshot
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$FILEPATH"

    # Copy to clipboard
    ${pkgs.wl-clipboard}/bin/wl-copy < "$FILEPATH"

    # Notify
    ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$FILENAME" -i "$FILEPATH"
  '';

  # Full screen screenshot
  screenshotFullScript = pkgs.writeShellScriptBin "screenshot-full" ''
    set -euo pipefail

    SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$SCREENSHOT_DIR"

    FILENAME="screenshot-$(date +%Y%m%d-%H%M%S).png"
    FILEPATH="$SCREENSHOT_DIR/$FILENAME"

    ${pkgs.grim}/bin/grim "$FILEPATH"

    ${pkgs.wl-clipboard}/bin/wl-copy < "$FILEPATH"

    ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$FILENAME" -i "$FILEPATH"
  '';

  # Screen recording toggle script (full screen)
  recordScript = pkgs.writeShellScriptBin "record-toggle" ''
    set -euo pipefail

    PIDFILE="/tmp/wf-recorder.pid"
    RECORDING_DIR="$HOME/Videos/Recordings"
    mkdir -p "$RECORDING_DIR"

    if [ -f "$PIDFILE" ]; then
      # Stop recording
      kill "$(cat "$PIDFILE")" 2>/dev/null || true
      rm -f "$PIDFILE"
      ${pkgs.libnotify}/bin/notify-send "Recording stopped" "Saved to $RECORDING_DIR"
    else
      # Start recording
      FILENAME="recording-$(date +%Y%m%d-%H%M%S).mp4"
      FILEPATH="$RECORDING_DIR/$FILENAME"
      ${pkgs.wf-recorder}/bin/wf-recorder -f "$FILEPATH" &
      echo $! > "$PIDFILE"
      ${pkgs.libnotify}/bin/notify-send "Recording started" "$FILENAME"
    fi
  '';

  # Area recording toggle script
  recordAreaScript = pkgs.writeShellScriptBin "record-area-toggle" ''
    set -euo pipefail

    PIDFILE="/tmp/wf-recorder.pid"
    RECORDING_DIR="$HOME/Videos/Recordings"
    mkdir -p "$RECORDING_DIR"

    if [ -f "$PIDFILE" ]; then
      # Stop recording
      kill "$(cat "$PIDFILE")" 2>/dev/null || true
      rm -f "$PIDFILE"
      ${pkgs.libnotify}/bin/notify-send "Recording stopped" "Saved to $RECORDING_DIR"
    else
      # Start area recording
      GEOMETRY="$(${pkgs.slurp}/bin/slurp)"
      if [ -n "$GEOMETRY" ]; then
        FILENAME="recording-$(date +%Y%m%d-%H%M%S).mp4"
        FILEPATH="$RECORDING_DIR/$FILENAME"
        ${pkgs.wf-recorder}/bin/wf-recorder -g "$GEOMETRY" -f "$FILEPATH" &
        echo $! > "$PIDFILE"
        ${pkgs.libnotify}/bin/notify-send "Recording started" "$FILENAME"
      fi
    fi
  '';
in
{
  home-manager.users.cnqso = { config, ... }: {
    home.packages = [
      screenshotScript
      screenshotFullScript
      recordScript
      recordAreaScript
    ];

    programs.niri.settings = {
      prefer-no-csd = true;

      # Always start Waybar alongside Niri.
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
        { command = [ "lxqt-policykit-agent" ]; }
      ];

      binds = {
        # Application launchers
        "Mod+T".action.spawn = ["kitty"];
        "Mod+Space".action.spawn = ["fuzzel"];

        # Window management
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

        # Move windows
        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+L".action.move-column-right = {};
        "Mod+Shift+J".action.move-window-down = {};
        "Mod+Shift+K".action.move-window-up = {};
        "Mod+Shift+Left".action.move-column-left = {};
        "Mod+Shift+Right".action.move-column-right = {};

        # Workspaces
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

        # Numbered workspaces
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

        # Column management
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Shift+Period".action.expel-window-from-column = {};

        # Emoji picker
        "Mod+Period".action.spawn = ["bemoji"];

        # Layout
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+C".action.center-column = {};

        # Monitor management
        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};
        "Mod+Ctrl+Right".action.focus-monitor-right = {};
        "Mod+Ctrl+Left".action.focus-monitor-left = {};

        # Screenshots and recording
        "Mod+S".action.spawn = ["screenshot"];
        "Print".action.spawn = ["screenshot-full"];
        "Mod+Shift+S".action.spawn = ["record-toggle"];
        "Mod+Ctrl+S".action.spawn = ["record-area-toggle"];

        # System
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        # Resize
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-column-width = "-10%";
        "Mod+Shift+Equal".action.set-column-width = "+10%";

        # Media keys
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
  };
}
