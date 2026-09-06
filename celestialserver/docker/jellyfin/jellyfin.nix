{ pkgs, ... }:
{
  sops.secrets."jellyfin_env" = {
    sopsFile = ./secrets.env;
    format = "binary";
    path = "/run/secrets/jellyfin.env";
    owner = "root";
    mode = "0400";
  };

  # Symlink both the compose file and the decrypted .env into /opt so
  # `docker compose up` (run from WorkingDirectory) finds them naturally.
  systemd.tmpfiles.rules = [
    "L+ /etc/jellyfin/.env - - - - /run/secrets/jellyfin.env"
    "L+ /etc/jellyfin/docker-compose.yml - - - - ${./docker-compose.yaml}"
  ];

  systemd.services.jellyfin = {
    description = "Jellyfin compose stack";
    after = [
      "docker.service"
      "sops-nix.service"
    ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/jellyfin";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      TimeoutStartSec = "300";
    };
  };

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
