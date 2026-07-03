{ config, ... }:
{
  services.nginx.virtualHosts."celestialserver.localdeer" = {
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

    virtualHosts."nextcloud.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:42633
        tls internal
      '';
    };

    virtualHosts."couchdb.localdeer" = {
      extraConfig = ''
        handle_path /e=_/* {
          reverse_proxy 127.0.0.1:5984
        }

        tls internal
        handle {
          respond "" 403
          header -Server ""
        }
      '';
    };

    virtualHosts."immich.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:2283
        tls internal
      '';
    };

    virtualHosts."pihole.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:3254
        tls internal
      '';
    };

    virtualHosts."vaultwarden.localdeer".extraConfig = ''
      encode zstd gzip

      reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {remote_host}
      }
      tls internal
    '';
  };

  environment.variables = {
    SSL_CERT_FILE = "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt";
    NIX_SSL_CERT_FILE = "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt";
  };

  # Open standard web ports globally for LAN and Tailscale
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Optional: Trust the tailscale interface completely if you face blocking issues
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
