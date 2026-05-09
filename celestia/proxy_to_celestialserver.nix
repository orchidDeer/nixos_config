{ config, ... }:
{
  sops.secrets.proxy_private_key = {
    sopsFile = ./proxy_private_key;
    format = "binary";
    # for permission, see man systemd.netdev
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;

    networks."50-wg1" = {
      matchConfig.Name = "wg1";

      address = [
        # /32 and /128 specifies a single address
        # for use on this wg peer machine
        "fd31:bf08:57cb::7/128"
        "192.168.26.7/32"
      ];
    };

    netdevs."50-wg1" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg1";
      };

      wireguardConfig = {
        ListenPort = 51820;

        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = config.sops.secrets.proxy_private_key.path;

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg1
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          # laptop wg conf
          PublicKey = "2PKBvO8EoXlN0mPfbybiPbBRl+Ewkt5zLIq6mbhw+wo=";
          AllowedIPs = [
            "fd31:bf08:57cb::9/128"
            "192.168.26.9/32"
          ];
          Endpoint = "celestialserver.orchiddeer.de:51820";

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };
}
