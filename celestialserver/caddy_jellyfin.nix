{
  services.caddy = {
    virtualHosts."jellyfin.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };

    virtualHosts."jellyseerr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:5055
      '';
    };

    virtualHosts."sonarr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:8989
      '';
    };

    virtualHosts."radarr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:7878
      '';
    };

    virtualHosts."jackett.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:9117
      '';
    };

    virtualHosts."flaresolverr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:8191
      '';
    };

    virtualHosts."bazarr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:6767
      '';
    };

    virtualHosts."prowlarr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:9696
      '';
    };

    virtualHosts."qbit.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };
  };
}
