{ pkgs, ... }:
let
  cottageLotusTheme = pkgs.stdenv.mkDerivation {
    pname = "sddm-theme-cottage-lotus";
    version = "1.2";
    src = builtins.path {
      path = ./sddm-theme-cottage;
      name = "cottage-theme-v1.2";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/cottage-lotus
      cp -r $src/* $out/share/sddm/themes/cottage-lotus/
      cp ${./home-manager/desktop/wallpaper.png} $out/share/sddm/themes/cottage-lotus/background.png
    '';
  };
in
{
  environment.systemPackages = [
    cottageLotusTheme
    pkgs.lora
  ];
  fonts.packages = [ pkgs.lora ];

  # cuz of crashes q.q
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    theme = "cottage-lotus";
    extraPackages = [ cottageLotusTheme ];
    settings = {
      General = {
        OutputName = "eDP-1";
      };
    };
  };

  # auto clear cash so theme reloads
  systemd.services.display-manager.preStart = ''
    rm -rf /var/lib/sddm/.cache
  '';
}
