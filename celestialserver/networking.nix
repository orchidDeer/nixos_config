{ config, ... }:
{
  sops.secrets.networking_wlan_pass = {
    sopsFile = ./networking_wlan_pass;
    format = "binary";
  };

  networking.hostName = "celestialserver"; # Define your hostname.
  networking.enableIPv6 = true;
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.default.forwarding" = 1;
  };

  networking.networkmanager.enable = false;
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.secretsFile = config.sops.secrets.networking_wlan_pass.path;
  networking.wireless.networks = {
    "Celestial-WLAN" = {
      pskRaw = "ext:wlanpass";
    };
  };

  networking.interfaces.enp3s0 = {
    ipv4.addresses = [
      {
        address = "192.168.10.1";
        prefixLength = 24;
      }
    ];
  };

  # Enable DHCP server
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ "enp3s0" ];
      };
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4.leases";
      };
      subnet4 = [
        {
          id = 1;
          subnet = "192.168.10.0/24";
          pools = [ { pool = "192.168.10.100 - 192.168.10.200"; } ];
          option-data = [
            {
              name = "routers";
              data = "192.168.10.1";
            }
          ];
        }
      ];
    };
  };

  networking.firewall.allowedUDPPorts = [ 67 ];

  networking.localCommands = ''
    ip link set enp3s0 up
  '';

  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Force the name to stay the same based on the MAC address
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="<9c:6b:00:03:dc:d3>", NAME="eth-direct"
  '';

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = "0"; # Disable reverse path filtering
    "net.ipv4.conf.default.rp_filter" = "0"; # Disable reverse path filtering for default interface
  };

  networking.firewall.trustedInterfaces = [ "enp3s0" ];
}
