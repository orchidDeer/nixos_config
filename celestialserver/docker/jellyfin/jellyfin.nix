{
  local.composeStacks.jellyfin = {
    files."docker-compose.yml" = ./docker-compose.yaml;
    envFile = ./secrets.env;
  };

  services.caddy = {
    virtualHosts."jellyfin.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };

    virtualHosts."seerr.localdeer, jellyseerr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:5055
      '';
    };

    virtualHosts."sonarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8989
      '';
    };

    virtualHosts."radarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:7878
      '';
    };

    virtualHosts."jackett.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:9117
      '';
    };

    virtualHosts."flaresolverr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8191
      '';
    };

    virtualHosts."bazarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:6767
      '';
    };

    virtualHosts."prowlarr.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:9696
      '';
    };

    virtualHosts."qbit.localdeer" = {
      extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };
  };
}
