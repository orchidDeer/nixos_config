{ ... }:
let
  wallpaper = ./wallpaper.png;
in
{
  home.file.".config/hypr/hyprpaper.conf".text = ''
    splash = false
    ipc = on

    wallpaper {
      monitor =
      path = ${wallpaper}
    }
  '';
  services.hyprpaper.enable = true;
}
