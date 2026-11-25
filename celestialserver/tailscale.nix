{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true; # 41641/udp
  };

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
  };

  systemd.services.tailscale-cert-renew = {
    description = "Renew Tailscale cert for Caddy";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.tailscale}/bin/tailscale cert --cert-file /var/lib/tailscale-certs/celestialserver.tail1ab1f7.ts.net.crt \
        --key-file /var/lib/tailscale-certs/celestialserver.tail1ab1f7.ts.net.key \
        celestialserver.tail1ab1f7.ts.net
      # tailscale writes the key as root-only; Caddy runs as user caddy
      chown root:caddy /var/lib/tailscale-certs/*
      chmod 0640 /var/lib/tailscale-certs/*
      # restart, not reload: reloads broke Caddy's internal cert renewal
      systemctl try-restart caddy
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/tailscale-certs 0750 root caddy -"
  ];

  systemd.timers.tailscale-cert-renew = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
