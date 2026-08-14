{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gtk3
    gtk4
  ];

  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Adwaita";
        cursor-theme = "Bibata-Modern-Classic";
        gtk-theme = "Orchis-Dark";
      };
    };
  };

  home.file.".config/gtk-4.0/gtk.css".source =
    "${pkgs.orchis-theme}/share/themes/Orchis-Dark/gtk-4.0/gtk.css";
  home.file.".config/gtk-4.0/gtk-dark.css".source =
    "${pkgs.orchis-theme}/share/themes/Orchis-Dark/gtk-4.0/gtk-dark.css";

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.orchis-theme;
      name = "Orchis-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
