{ config, ... }:
{
  services.nginx.virtualHosts."celestialserver.orchiddeer.de" = {
    listen = [
      {
        addr = "localhost";
        port = 42633;
      }
    ];
  };

  services.caddy = {
    enable = true;
    email = "caddy@orchiddeer.de";

    virtualHosts."nextcloud.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:42633
      '';
    };

    virtualHosts."couchdb.orchiddeer.de" = {
      extraConfig = ''
        handle_path /e=_/* {
          reverse_proxy localhost:5984
        }

        handle {
          respond "" 403
          header -Server ""
        }
      '';
    };

    virtualHosts."immich.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:2283
      '';
    };

    virtualHosts."vaultwarden.orchiddeer.de".extraConfig = ''
      encode zstd gzip

      reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {remote_host}
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
