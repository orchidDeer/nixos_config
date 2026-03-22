{ pkgs, ... }:
{
  home.username = "juna";
  home.homeDirectory = "/home/juna";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    thunderbird
    krita
    legcord
    zed-editor
    prismlauncher

    gcc
    gnumake
    nil
    rust-analyzer
    cargo
    rustc
    rustfmt
    clippy
    nixd
  ];

  imports = [
    ../bash.nix
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "rust"
      "html"
      "Material Icon Theme"
      "Everforest Blurred"
    ];
    userSettings = {
      theme = {
        mode = "dark";
        dark = "Everforest Blurred";
        light = "Ayu Light";
      };
      icon_theme = "Material Icon Theme";
      ui_font_size = 16;
      buffer_font_size = 15;

      lsp = {
        rust-analyzer = {
          binary = {
            # path = lib.getExe pkgs.rust-analyzer;
            path_lookup = true;
          };
        };
      };
    };
  };
}
