{
  pkgs,
  ...
}:
let
  system = pkgs.system;
in
{
  imports = [
    ../../bash.nix
    ./bash.nix
    ./zeditor.nix
    ./desktop/desktop.nix
    ./librewolf.nix
    ./obsidian.nix
    ./ssh.nix
  ];

  home.username = "juna";
  home.homeDirectory = "/home/juna";

  home.stateVersion = "26.05";
  home.pointerCursor.enable = true;

  home.packages = with pkgs; [
    thunderbird
    krita
    legcord
    prismlauncher
    prusa-slicer
    jellyfin-desktop
    moonlight-qt
    btop
    signal-desktop
    dig
    openssl
    nextcloud-client
    nil
    nixd
    nixfmt
    nautilus
    nwg-look

    rapidraw

    chromium
    joplin-desktop
    freecad
  ];

  programs.direnv.enable = true;
}
