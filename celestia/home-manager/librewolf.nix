{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    profiles.juna = {
      isDefault = true;

      settings = {
        "extensions.autoDisableScopes" = 0;

        # WebGL Activation
        "webgl.disabled" = false;
        "webgl.force-enabled" = true;

        # Legacy Protection (Disabled)
        "privacy.resistFingerprinting" = false;

        # New Protection (Enabled with WebGL bypass)
        "privacy.fingerprintingProtection" = true;
        # Added -WebGL to the targets to prevent it from being blocked/spoofed
        "privacy.fingerprintingProtection.overrides" =
          "+AllTargets,-CSSPrefersColorScheme,-WebGLRenderInfo,-WebGLRenderCapability";

        # Dark Theme Overrides
        "layout.css.prefers-color-scheme.content-override" = 2;
        "ui.systemUsesDarkTheme" = 2;
      };

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
