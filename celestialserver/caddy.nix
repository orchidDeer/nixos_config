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

    # Restart instead of hot-reload on config changes. After a reload Caddy's
    # cert maintenance lost track of its certs ("no configuration associated
    # with certificate") and stopped renewing them.
    enableReload = false;

    # Internal CA for *.localdeer. Defaults are 12h leaf / 7d intermediate,
    # which break quickly if a renewal is missed. Root stays the same (valid to 2036).
    globalConfig = ''
      pki {
        ca local {
          intermediate_lifetime 365d
        }
      }
      cert_issuer internal {
        lifetime 90d
      }
    '';

    virtualHosts."nextcloud.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:42633
      '';
    };

    virtualHosts."pihole.localdeer" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:3254
      '';
    };

    virtualHosts."budget.localdeer".extraConfig = ''
      reverse_proxy 127.0.0.1:5006

      handle /enable-actual-callback* {
        reverse_proxy 127.0.0.1:3000
      }

    '';

    virtualHosts."vaultwarden.localdeer".extraConfig = ''
      encode zstd gzip

      reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {remote_host}
      }
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
}
