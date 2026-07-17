{
  pkgs,
  ...
}:
{
  imports = [
    ../../bash.nix
    ./bash.nix
    ./zeditor.nix
    ./desktop/desktop.nix
    ./librewolf.nix
  ];

  home.username = "juna";
  home.homeDirectory = "/home/juna";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    thunderbird
    krita
    legcord
    zed-editor
    prismlauncher
    prusa-slicer
    jellyfin-desktop
    moonlight-qt
    steam
    btop
    signal-desktop
    dig
    obsidian
    openssl
    nextcloud-client
    nil
    nixd
    nixfmt
    firefox
    nautilus
    nwg-look
  ];

  programs.direnv.enable = true;
}
