{ config, ... }:
{
  #add svg
  home.file.".config/waybar/icons/VolumeOn.svg".source = ./icons/VolumeOn.svg;
  home.file.".config/waybar/icons/Wifi.svg".source = ./icons/Wifi.svg;
  home.file.".config/waybar/icons/Battery.svg".source = ./icons/Battery.svg;

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
        spacing = 0;

        #add svg
        "image#VolumeOn" = {
          path = "${config.home.homeDirectory}/.config/waybar/icons/VolumeOn.svg";
          size = 20;
        };
        "image#Wifi" = {
          path = "${config.home.homeDirectory}/.config/waybar/icons/Wifi.svg";
          size = 20;
        };
        "image#Battery" = {
          path = "${config.home.homeDirectory}/.config/waybar/icons/Battery.svg";
          size = 20;
        };

        modules-left = [
          "hyprland/submap"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "image#VolumeOn" #add svg
          "pulseaudio"
          "image#Wifi" #add svg
          "network"
          "image#Battery" #add svg
          "battery"
          "clock"
          "tray"
        ];

        "hyprland/window" = {
          max-length = 40;
          separate-outputs = true;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "muted";
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
          format-wifi = " {signalStrength}%";
          format-ethernet = "wired";
          format-disconnected = "offline";
          tooltip-format = "{ifname} via {gwaddr}";

          on-click = "kitty nmtui";
        };

        battery = {
          states = {
            dim = 94;
            warning = 30;
            critical = 15;
          };
          interval = 5;
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = "⚡ {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-full = "🔌 {capacity}%";
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
        margin-left: 0;
        margin-right: 0;
      }

      window#waybar {
        background: transparent;
        padding: 0;
        margin: 4px 6px;
      }

      #workspaces,
      #window,
      #clock,
      #tray {
        background: rgba(30, 30, 46, 0.75);
        color: #cdd6f4;
        padding: 0 12px;
        margin: 3px 2px;
        border-radius: 10px;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
        background-color: transparent;
        background-image: url("${config.home.homeDirectory}/.config/waybar/icons/pawGray.svg");
        background-repeat: no-repeat;
        background-position: center;
        background-size: contain;

        transition: none;

        padding: 0;
        margin: 4px 6px;
      }

      #workspaces button.active {
        color: #cdd6f4;
        background-image: url("${config.home.homeDirectory}/.config/waybar/icons/pawPink.svg");
        background-color: transparent;
        transition: none;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
      }

      #clock {
        font-weight: bold;
        font-size: 13px;
        margin: 3px 2px;
      }

      #image.Battery, #battery {
        background: rgba(30, 30, 46, 0.75);
        margin: 3px 2px;
       }

      #image.Battery {
         margin-right: 0;
         margin-left: 4px;
         border-radius: 10px 0 0 10px;
         padding: 0 2px 0 10px;
       }

       #battery.discharging, #battery.charging, #battery.plugged, #battery.full {
         color: #41DE2A;
         margin-left: 0;
         margin-right: 4px;
         border-radius: 0 10px 10px 0;
         padding: 0 10px 0 2px;
       }

      #battery.dim.discharging {
      color: #cdd6f4;
      }

      #battery.warning.discharging {
        color: #FFD014;
      }

      #battery.critical.discharging {
        color: #FF0A0A;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #image.VolumeOn, #pulseaudio {
        background: rgba(30, 30, 46, 0.75);
        margin: 3px 2px;
        }

      #image.VolumeOn {
        margin-right: 0;
        border-radius: 10px 0 0 10px;
        padding: 0 2px 0 10px;
      }

      #pulseaudio {
        margin-left: 0;
        border-radius: 0 10px 10px 0;
        padding: 0 10px 0 2px;
      }

       #image.Wifi, #network {
        background: rgba(30, 30, 46, 0.75);
        margin: 3px 2px;
        }

      #image.Wifi {
        margin-right: 0;
        margin-left: 4px;
        border-radius: 10px 0 0 10px;
        padding: 0 2px 0 10px;
      }

      #network {
        margin-left: 0;
        margin-right: 4px;
        border-radius: 0 10px 10px 0;
        padding: 0 10px 0 2px;
      }
    '';
  };
}
