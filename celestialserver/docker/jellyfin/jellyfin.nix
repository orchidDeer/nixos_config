{
  local.composeStacks.jellyfin = {
    files."docker-compose.yml" = ./docker-compose.yaml;
    envFile = ./secrets.env;
  };

  services.caddy = {
    virtualHosts."jellyfin.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8096
      '';
    };

    virtualHosts."seerr.localdeer, jellyseerr.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:5055
      '';
    };

    virtualHosts."sonarr.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8989
      '';
    };

    virtualHosts."radarr.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:7878
      '';
    };

    virtualHosts."jackett.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:9117
      '';
    };

    virtualHosts."flaresolverr.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8191
      '';
    };

    virtualHosts."bazarr.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:6767
      '';
    };

    virtualHosts."prowlarr.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:9696
      '';
    };

    virtualHosts."qbit.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';
    };
  };
}
