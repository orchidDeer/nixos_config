{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    profiles.juna = {
      isDefault = true;

      extensions = {
        force = true;

        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
        ];
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "";
                url = "https://youtube.com/feed/subscriptions";
              }
            ];
          }
        ];
      };

      search = {
        force = true;
        order = [
          "google"
          "ddg"
        ];

        default = "google";
      };
    };

    policies.ExtensionSettings = {
      "myallychou@gmail.com" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
}
