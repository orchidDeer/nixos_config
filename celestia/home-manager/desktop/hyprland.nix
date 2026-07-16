{ lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

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
        {
          _args = [
            "SUPER+Q"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("kitty")'')
          ];
        }
        {
          _args = [
            "SUPER+C"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill waybar || waybar")'')
          ];
        }
        {
          _args = [
            "SUPER+P"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("walker")'')
          ];
        }
        {
          _args = [
            "SUPER+E"
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            "SUPER+right"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "r+1" })'')
          ];
        }
        {
          _args = [
            "SUPER+left"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "r-1" })'')
          ];
        }
        {
          _args = [
            "SUPER+SHIFT+right"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "r+1" })'')
          ];
        }
        {
          _args = [
            "SUPER+SHIFT+left"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "r-1" })'')
          ];
        }
        {
          _args = [
            "SUPER+SHIFT+r"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprctl reload")'')
          ];
        }
      ];
    };
  };
}
