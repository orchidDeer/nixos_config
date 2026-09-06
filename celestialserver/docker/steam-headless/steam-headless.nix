{ pkgs, ... }:
{
  sops.secrets."steam_headless_env" = {
    sopsFile = ./secrets.env;
    format = "binary";
    path = "/run/secrets/steam_headless.env";
    owner = "root";
    mode = "0400";
  };

  # Symlink both the compose file and the decrypted .env into /opt so
  # `docker compose up` (run from WorkingDirectory) finds them naturally.
  systemd.tmpfiles.rules = [
    "L+ /opt/container-services/steam-headless/.env - - - - /run/secrets/steam_headless.env"
    "L+ /opt/container-services/steam-headless/docker-compose.yml - - - - ${./docker-compose.yml}"
  ];

  systemd.services.steam-headless = {
    description = "Steam headless compose stack";
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
      WorkingDirectory = "/opt/container-services/steam-headless";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      TimeoutStartSec = "300";
    };
  };

  services.caddy.virtualHosts."sunshine.localdeer" = {
    extraConfig = ''
      reverse_proxy https://127.0.0.1:47990 {
        transport http {
          tls_insecure_skip_verify
        }
      }
      tls internal
    '';
  };
}
