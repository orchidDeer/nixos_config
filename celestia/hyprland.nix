{ pkgs, ... }: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.hyprland.xwayland.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config = {
      Hyprland = {
        default = [
          "gnome"
          "gtk"
        ];
        Settings = "gnome";
        ScreenCast = "hyprland";
        Screenshot = "hyprland";
      };
    };
  };
}
