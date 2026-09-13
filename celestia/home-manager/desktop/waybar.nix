{ config, ... }:
{
  # add svg
  home.file.".config/waybar/icons/battery.svg".source = ./icons/battery.svg;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];

        # add svg
        "image#battery-test" = {
          path = "${config.home.homeDirectory}/.config/waybar/icons/battery.svg";
          size = 34;
        };

        modules-center = [ "hyprland/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "image#battery-test"   # add svg
          "battery"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          max-length = 40;
          separate-outputs = true;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "婢 muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pwvucontrol";
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀 wired";
          format-disconnected = "󰤭 offline";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = " {capacity}%";
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %d %B %Y}";
          tooltip-format = "{:%Y-%m-%d}";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      #workspaces,
      #window,
      #pulseaudio,
      #network,
      #clock,
      #tray {
        background: rgba(30, 30, 46, 0.75);
        color: #cdd6f4;
        padding: 0 12px;
        margin: 4px 2px;
        border-radius: 12px;
      }

      #image.battery-test, #battery {
        background: rgba(30, 30, 46, 0.75);
        margin: 4px 0;
      }
      #image.battery-test {
        margin-right: 0;
        border-radius: 12px 0 0 12px;
        padding: 0 2px 0 10px;
      }
      #battery {
        margin-left: 0;
        border-radius: 0 12px 12px 0;
        padding: 0 12px 0 2px;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
      }

      #workspaces button.active {
        color: #cdd6f4;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
      }

      #clock {
        font-weight: bold;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }
    '';
  };
}
