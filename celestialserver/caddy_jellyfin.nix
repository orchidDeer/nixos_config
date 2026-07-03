{
  services.caddy = {
    virtualHosts."jellyfin.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8096
        tls internal
      '';
    };

    virtualHosts."jellyseerr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:5055
        tls internal
      '';
    };

    virtualHosts."sonarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8989
        tls internal
      '';
    };

    virtualHosts."radarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:7878
        tls internal
      '';
    };

    virtualHosts."jackett.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:9117
        tls internal
      '';
    };

    virtualHosts."flaresolverr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8191
        tls internal
      '';
    };

    virtualHosts."bazarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:6767
        tls internal
      '';
    };

    virtualHosts."prowlarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:9696
        tls internal
      '';
    };

    virtualHosts."qbit.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8080
        tls internal
      '';
    };
  };
}
