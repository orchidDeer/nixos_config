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
            "comment" = {
              "color" = "#C3DECAFF";
            };
            "variable" = {
              "color" = "#FFEBFBFF";
            };
            "label" = {
              "color" = "#7A515100";
            };
            "tag" = {
              "color" = "#C9E5FFFF";
            };
          };
        };
      };
    };
  };
}
