{ config, ... }:
{
  systemd.services.wpa_supplicant = {
    serviceConfig = {
      # Append the sops secret path to the existing systemd sandbox paths
      ReadWritePaths = [
        config.sops.secrets.networking_wlan_pass.path
      ];
    };
  };

  sops.secrets.networking_wlan_pass = {
    sopsFile = ./networking_wlan_pass;
    format = "binary";
    group = "wpa_supplicant";
    mode = "0440";
  };

  networking = {
    hostName = "celestialserver";

    enableIPv6 = true;

    networkmanager.enable = false;
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.networking_wlan_pass.path;
      interfaces = [ "wlp4s0" ];
      networks = {
        "Celestial-WLAN" = {
          pskRaw = "ext:wlanpass";
        };
      };
    };

    # Let kernel decide routes normally
    useDHCP = false;
    interfaces.wlp4s0.useDHCP = true;

    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
  };

  networking.interfaces.wlp4s0.ipv4.addresses = [
    {
      address = "192.168.2.111";
      prefixLength = 16;
    }
  ];

  networking.firewall = {
    enable = true;

    allowedUDPPorts = [
      53
      41641
    ];
    allowedTCPPorts = [ 53 ];

    checkReversePath = "loose";

    trustedInterfaces = [
      "tailscale0"
    ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;

    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;
  };
}
