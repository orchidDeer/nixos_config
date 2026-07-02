{ config, ... }:
{
  services.nginx.virtualHosts."celestialserver.orchiddeer.de" = {
    listen = [
      {
        addr = "127.0.0.1"; # Changed from "localhost" for strict IPv4 routing
        port = 42633;
      }
    ];
  };

  services.caddy = {
    enable = true;
    email = "caddy@orchiddeer.de";

    virtualHosts."qbit.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';
    };

    virtualHosts."nextcloud.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:42633
      '';
    };

    virtualHosts."couchdb.orchiddeer.de" = {
      extraConfig = ''
        handle_path /e=_/* {
          reverse_proxy 127.0.0.1:5984
        }

        handle {
          respond "" 403
          header -Server ""
        }
      '';
    };

    virtualHosts."immich.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:2283
      '';
    };

    virtualHosts."pihole.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:3254
      '';
    };

    virtualHosts."vaultwarden.orchiddeer.de".extraConfig = ''
      encode zstd gzip

      reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {remote_host}
      }
    '';
  };

  # Open standard web ports globally for LAN and Tailscale
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Optional: Trust the tailscale interface completely if you face blocking issues
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
