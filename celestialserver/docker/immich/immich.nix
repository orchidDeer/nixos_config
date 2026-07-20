{ pkgs, ... }:
{
  sops.secrets."immich_env" = {
    sopsFile = ./secrets.env;
    format = "binary";
    path = "/run/secrets/immich.env";
    owner = "root";
    mode = "0400";
  };

  # docker-compose.yml uses `env_file: - .env` per service, which compose
  # resolves relative to its own directory (/etc/immich) — not via --env-file.
  # Symlink the sops-decrypted secret there so compose finds it naturally.
  systemd.tmpfiles.rules = [
    "L+ /etc/immich/.env - - - - /run/secrets/immich.env"
  ];

  environment.etc."immich/docker-compose.yml".source = ./docker-compose.yml;
  environment.etc."immich/hwaccel.ml.yml".source = ./hwaccel.ml.yml;
  environment.etc."immich/hwaccel.transcoding.yml".source = ./hwaccel.transcoding.yml;

  systemd.services.immich = {
    description = "Immich compose stack";
    after = [
      "docker.service"
      "network-online.target"
      "sops-nix.service"
    ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/immich";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      TimeoutStartSec = "300";
    };
  };

  services.caddy.virtualHosts."immich.localdeer" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:2283
      tls internal
    '';
  };
}
