{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";

    allowedUDPPorts = [
      53
      41641
    ];
    allowedTCPPorts = [ 53 ];
  };

  systemd.services.tailscale-cert-renew = {
    description = "Renew Tailscale cert for Caddy";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.tailscale}/bin/tailscale cert --cert-file /var/lib/tailscale-certs/celestialserver.tail1ab1f7.ts.net.crt \
        --key-file /var/lib/tailscale-certs/celestialserver.tail1ab1f7.ts.net.key \
        celestialserver.tail1ab1f7.ts.net
      systemctl reload caddy
    '';
  };

  systemd.timers.tailscale-cert-renew = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
