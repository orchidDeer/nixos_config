{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  wallpaper = ./wallpaper.png;

  bind = key: action: {
    _args = [
      key
      (lua action)
    ];
  };

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  focusWs = ws: ''hl.dsp.focus({ workspace = "${ws}" })'';
  moveWs = ws: ''hl.dsp.window.move({ workspace = "${ws}" })'';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.variables = [ "--all" ];
    settings = {
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 0;
        };
        decoration = {
          rounding = 10;
        };
      };
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      };
      bind = [
        (bind "SUPER+T" (exec "kitty"))
        (bind "SUPER+C" (exec "pkill waybar || waybar"))
        (bind "SUPER+P" (exec "walker"))
        (bind "SUPER+A" (exec "pwvucontrol"))
        (bind "SUPER+B" (exec "blueman-manager"))
        (bind "SUPER+Q" "hl.dsp.window.close()")

        (bind "SUPER+right" (focusWs "r+1"))
        (bind "SUPER+left" (focusWs "r-1"))
        (bind "SUPER+SHIFT+right" (moveWs "r+1"))
        (bind "SUPER+SHIFT+left" (moveWs "r-1"))
        (bind "SUPER+SHIFT+r" (exec "hyprctl reload"))
      ];
    };

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd('hyprctl hyprpaper wallpaper ",${wallpaper}"')
      end)
    '';
  };
}
