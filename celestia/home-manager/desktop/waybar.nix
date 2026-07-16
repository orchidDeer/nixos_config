{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        positon = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "clock"
          "tray"
        ];

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%Y-%m-%d}";
        };
      };
    };

    style = ''
      * {
        border: none;
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
      }
      window#waybar {
        background: rgba(43, 48, 59, 0.5);
        color: #ffffff;
      }
    '';
  };
}
