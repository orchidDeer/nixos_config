{
  # 1. Netzwerk-Ports in der Firewall freigeben
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      53
      67
      68
    ];
    allowedTCPPorts = [ 53 ]; # Aktiviert den DNS-Port für TCP-Abfragen
  };

  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    useDnsmasqConfig = true;

    settings = {
      dns = {
        # Externe DNS-Upstreams
        upstreams = [
          "9.9.9.9"
          "1.1.1.1"
        ];
        hosts = [ ];
        interface = "all";
        listeningMode = "ALL";
      };

      misc.dnsmasq_lines = [
        "address=/.localdeer/192.168.2.111"
        "host-record=localdeer,192.168.2.111"

        "address=/.localdeer/100.73.254.48"
        "host-record=localdeer,100.73.254.48"
      ];

      misc.local_networks = [
        "127.0.0.1/8"
        "192.168.0.0/16"
        "100.64.0.0/10"
      ];
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "hagezi blocklist";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ "3254" ];
  };
}
