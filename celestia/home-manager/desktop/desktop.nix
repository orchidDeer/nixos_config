{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./walker.nix
    ./waybar.nix
    ./gtk.nix
    ./qt.nix
    ./pwvucontrol.nix
    ./wallpaper.nix
  ];


  home.packages = with pkgs; [
    hyprshot
    satty
    wl-clipboard
  ];
}
