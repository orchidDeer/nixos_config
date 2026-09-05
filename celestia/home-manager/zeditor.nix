{ ... }:
{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;
    extensions = [
      "nix"
      "toml"
      "rust"
      "html"
      "qml"
      "svelte"
      "js"
      "ts"
      "material-icon-theme"
      "everforest-blurred"
      "git-firefly"
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

      languages = {
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
      };

      lsp = {
        rust-analyzer = {
          binary = {
            # path = lib.getExe pkgs.rust-analyzer;
            path_lookup = true;
          };
        };
      };

      theme_overrides = {
        "Everforest Blurred" = {
          "syntax" = {
            "keyword" = {"color" = "#FFD0A6"; "font_style" = "italic"; }; #orange
            "string" = {"color" = "#CBFFB0"; }; #green
            "variable" = {"color" = "#FCB8CF"; }; #pink
            "function" ={"color" = "#BDFCFF"; }; #lightblue
            "number" = {"color" = "#BDCAFF"; }; #purple
            "link-text" = {"color" = "#4F58D1"; }; #blue
            "tag" = {"color" = "#F2D9FF"; }; #lilac
            "punctuation.bracket" = {"color" = "#E9D2F7"; };
          };
        };
      };
    };
  };
}
