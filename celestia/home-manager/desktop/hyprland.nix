{ pkgs, lib, ... }:
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
  moveMon = dir: ''hl.dsp.window.move({ monitor = "${dir}" })'';

  laptop = "eDP-1";
  lgTv = "desc:LG Electronics LG TV SSCR2 0x01010101";
  ugdMonitor = "desc:UGD MD160QH 20240606";

  monitorToggle = pkgs.writeShellScriptBin "hypr-monitor-toggle" ''
    set -euo pipefail

    STATE_FILE="/tmp/hypr-monitor-mode"
    MODE="triple"
    [ -f "$STATE_FILE" ] && MODE=$(cat "$STATE_FILE")

    eval_lua() { hyprctl eval "$1"; }

    apply_single() {
      eval_lua 'hl.monitor({ output = "${laptop}", mode = "preferred", position = "0x0", scale = 1, disabled = false })'
      eval_lua 'hl.monitor({ output = "${lgTv}", disabled = true })'
      eval_lua 'hl.monitor({ output = "${ugdMonitor}", disabled = true })'
      echo single > "$STATE_FILE"
    }

    apply_triple() {
      eval_lua 'hl.monitor({ output = "${laptop}", mode = "preferred", position = "0x0", scale = 1, disabled = false })'
      eval_lua 'hl.monitor({ output = "${lgTv}", mode = "preferred", position = "-640x-2160", scale = 1, disabled = false })'
      eval_lua 'hl.monitor({ output = "${ugdMonitor}", mode = "preferred", position = "2560x0", scale = 1, disabled = false })'
      echo triple > "$STATE_FILE"
    }

    if [ "$MODE" = "single" ]; then
      apply_triple
    else
      apply_single
    fi
  '';
in
{
  home.packages = [ monitorToggle ];

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

      # Declarative default layout — applied automatically on every start/reload,
      # no exec script needed for this to take effect.
      monitor = [
        {
          output = laptop;
          mode = "preferred";
          position = "0x0";
          scale = 1;
        }
        {
          output = lgTv;
          mode = "preferred";
          position = "-640x-2160";
          scale = 1;
        }
        {
          output = ugdMonitor;
          mode = "preferred";
          position = "2560x0";
          scale = 1;
        }
        {
          # fallback for anything unmatched, e.g. a random new monitor plugged in
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

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

        (bind "SUPER+ALT+left" (moveMon "l"))
        (bind "SUPER+ALT+right" (moveMon "r"))
        (bind "SUPER+ALT+up" (moveMon "u"))
        (bind "SUPER+ALT+down" (moveMon "d"))
        (bind "SUPER+SHIFT+m" (exec "hypr-monitor-toggle"))
      ];
    };
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd('hyprctl hyprpaper wallpaper ",${wallpaper}"')
      end)
    '';
  };
}
