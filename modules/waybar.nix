{ pkgs, config, ... }:

{
  # Universal waybar configuration for all hosts
  home-manager.users.cnqso = { config, ... }: let
    # Stylix colors for injection into CSS
    c = config.lib.stylix.colors;
  in {
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
            format = " {used:0.1f}G/{total:0.1f}G";
            states = {
              warning = 70;
              critical = 90;
            };
            tooltip = false;
          };

          network = {
            interval = 5;
            format-wifi = " {essid} ({signalStrength}%)";
            format-ethernet = " {ifname}";
            format-disconnected = "No connection";
            format-alt = " {ipaddr}/{cidr}";
            on-click = "nm-connection-editor";
            on-click-right = "kitty -e nmtui";
            tooltip = false;
          };

          "niri/window" = {
            format = "{}";
            max-length = 30;
            tooltip = false;
          };

          "niri/workspaces" = {
            format = "{icon}";
            "format-icons" = {
              "active" = "*";
              "default" = "*";
            };
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}%";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
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

      style = ''
        /* Keyframes */
        @keyframes blink-critical {
          to {
            background-color: #${c.base08};
          }
        }

        /* Semantic waybar colors mapped directly to base16 roles */
        @define-color warning    #${c.base0A};  /* Classes, Markup Bold, Search Text Background */
        @define-color critical   #${c.base08};  /* Variables, XML Tags, Markup Link Text, Diff Deleted */
        @define-color mode       #${c.base00};  /* Default Background */
        @define-color unfocused  #${c.base03};  /* Lighter Background (Used for status bars) */
        @define-color focused    #${c.base0C};  /* Support, Regular Expressions, Escape Characters, Markup Quotes */
        @define-color inactive   #${c.base0E};  /* Keywords, Storage, Selector, Markup Italic, Diff Changed */
        @define-color sound      #${c.base0E};  /* Keywords, Storage, Selector, Markup Italic, Diff Changed */
        @define-color network    #${c.base0D};  /* Functions, Methods, Attribute IDs, Headings */
        @define-color memory     #${c.base0C};  /* Support, Regular Expressions, Escape Characters, Markup Quotes */
        @define-color cpu        #${c.base0B};  /* Strings, Inherited Class, Markup Code, Diff Inserted */
        @define-color temp       #${c.base09};  /* Integers, Boolean, Constants, XML Attributes, Markup Link Url */
        @define-color layout     #${c.base00};  /* Classes, Markup Bold, Search Text Background */
        @define-color battery    #${c.base0C};  /* Default Background */
        @define-color date       #${c.base00};  /* Default Background */
        @define-color time       #${c.base05};  /* Default Foreground, Caret, Delimiters, Operators */
        
        /* Basic text and background colors */
        @define-color fg         #${c.base05};  /* Default Foreground, Caret, Delimiters, Operators */
        @define-color bg         #${c.base00};  /* Default Background */

        /* Reset all styles */
        * {
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 0;
          padding: 0;
          box-shadow: none;
          text-shadow: none;
          icon-shadow: none;
        }

        /* The whole bar */
        #waybar {
          background: @bg;
          color: @fg;
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: 10pt;
          font-weight: normal;
        }

        /* Each module */
        #battery,
        #clock,
        #cpu,
        #language,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #temperature,
        #tray,
        #backlight,
        #idle_inhibitor,
        #disk,
        #user,
        #mpris {
          padding-left: 8pt;
          padding-right: 8pt;
        }

        /* Each critical module */
        #mode,
        #memory.critical,
        #cpu.critical,
        #temperature.critical,
        #battery.critical.discharging {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
          animation-name: blink-critical;
          animation-duration: 1s;
        }

        /* Each warning */
        #network.disconnected,
        #memory.warning,
        #cpu.warning,
        #temperature.warning,
        #battery.warning.discharging {
          color: @warning;
        }

        /* Current sway mode (resize etc) */
        #mode {
          color: @fg;
          background: @mode;
        }

        /* Workspaces stuff */
        #workspaces button {
          padding-left: 2pt;
          padding-right: 2pt;
          color: @fg;
          background: @unfocused;
        }

        /* Inactive (on unfocused output) */
        #workspaces button.visible {
          color: @fg;
          background: @inactive;
        }

        /* Active (on focused output) */
        #workspaces button.focused {
          color: @bg;
          background: @focused;
        }

        /* Contains an urgent window */
        #workspaces button.urgent {
          color: @bg;
          background: @warning;
        }

        /* Style when cursor is on the button */
        #workspaces button:hover {
          background: @bg;
          color: @fg;
        }

        #window {
          margin-right: 35pt;
          margin-left: 35pt;
        }

        #pulseaudio {
          background: @sound;
          color: @bg;
        }

        #network {
          background: @network;
          color: @bg;
        }

        #memory {
          background: @memory;
          color: @bg;
        }

        #cpu {
          background: @cpu;
          color: @bg;
        }

        #temperature {
          background: @temp;
          color: @bg;
        }

        #language {
          background: @bg;
          color: @bg;
        }

        #battery {
          background: @battery;
          color: @bg;
        }

        #tray {
          background: @date;
        }

        #clock.date {
          background: @date;
          color: @fg;
        }

        #clock.time {
          background: @time;
          color: @bg;
        }

        #custom-arrow1 {
          font-size: 11pt;
          color: @time;
          background: @date;
        }

        #custom-arrow2 {
          font-size: 11pt;
          color: @date;
          background: @layout;
        }

        #custom-arrow3 {
          font-size: 11pt;
          color: @layout;
          background: @battery;
        }

        #custom-arrow4 {
          font-size: 11pt;
          color: @battery;
          background: @temp;
        }

        #custom-arrow5 {
          font-size: 11pt;
          color: @temp;
          background: @cpu;
        }

        #custom-arrow6 {
          font-size: 11pt;
          color: @cpu;
          background: @memory;
        }

        #custom-arrow7 {
          font-size: 11pt;
          color: @memory;
          background: @network;
        }

        #custom-arrow8 {
          font-size: 11pt;
          color: @network;
          background: @sound;
        }

        #custom-arrow9 {
          font-size: 11pt;
          color: @sound;
          background: transparent;
        }

        #custom-arrow10 {
          font-size: 11pt;
          color: @unfocused;
          background: transparent;
        }
      '';
    };
  };
}
