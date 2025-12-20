{ pkgs, ... }:

{
  # Universal waybar configuration for all hosts
  home-manager.users.cnqso = {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";

          modules-left = [
            "niri/workspaces"
            "custom/arrow10"
            "niri/window"
          ];

          modules-right = [
            "custom/arrow9"
            "pulseaudio"
            "custom/arrow8"
            "network"
            "custom/arrow7"
            "memory"
            "custom/arrow6"
            "cpu"
            "custom/arrow5"
            "temperature"
            "custom/arrow4"
            "battery"
            "custom/arrow3"
            "tray"
            "clock#date"
            "custom/arrow1"
            "clock#time"
          ];

          # Modules configuration
          battery = {
            interval = 10;
            states = {
              warning = 30;
              critical = 15;
            };
            format-time = "{H}:{M:02}";
            format = "{icon} {capacity}% ({time})";
            format-charging = " {capacity}% ({time})";
            format-charging-full = " {capacity}%";
            format-full = "{icon} {capacity}%";
            format-alt = "{icon} {power}W";
            format-icons = [ "" "" "" "" "" ];
            tooltip = false;
          };

          "clock#time" = {
            interval = 10;
            format = "{:%I:%M}";
            tooltip = false;
          };

          "clock#date" = {
            interval = 20;
            format = "{:%e %b %Y}";
            tooltip = false;
          };

          cpu = {
            interval = 5;
            tooltip = false;
            format = " {usage}%";
            format-alt = " {load}";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          memory = {
            interval = 5;
            format = " {used:0.1f}G/{total:0.1f}G";
            states = {
              warning = 70;
              critical = 90;
            };
            tooltip = false;
          };

          network = {
            interval = 5;
            format-wifi = " {essid} ({signalStrength}%)";
            format-ethernet = " {ifname}";
            format-disconnected = "No connection";
            format-alt = " {ipaddr}/{cidr}";
            tooltip = false;
          };

          "niri/window" = {
            format = "{}";
            max-length = 30;
            tooltip = false;
          };

          "niri/workspaces" = {
            format = "{name}";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}%";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" ];
            };
            scroll-step = 1;
            on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            tooltip = false;
          };

          temperature = {
            critical-threshold = 90;
            interval = 5;
            format = "{icon} {temperatureC}°";
            format-icons = [ "" "" "" "" "" ];
            tooltip = false;
          };

          tray = {
            icon-size = 18;
          };

          # Custom arrow modules for styling
          "custom/arrow1" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow2" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow3" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow4" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow5" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow6" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow7" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow8" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow9" = {
            format = "";
            tooltip = false;
          };

          "custom/arrow10" = {
            format = "";
            tooltip = false;
          };
        };
      };

    style = ../waybar/style.css;
    };
  };
}
