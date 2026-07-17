{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gtk3
    gtk4
    gsettings-desktop-schemas
    glib
  ];

  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Adwaita";
        cursor-theme = "Bibata-Modern-Classic";
        gtk-theme = "Flat-Remix-GTK-Grey-Darkest";
      };
    };
  };

  home.file.".config/gtk-4.0/gtk.css".source =
    "${pkgs.flat-remix-gtk}/share/themes/Flat-Remix-GTK-Grey-Darkest/gtk-4.0/gtk.css";
  home.file.".config/gtk-4.0/gtk-dark.css".source =
    "${pkgs.flat-remix-gtk}/share/themes/Flat-Remix-GTK-Grey-Darkest/gtk-4.0/gtk-dark.css";

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
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
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
