{
  networking.hostName = "celestialserver"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    "Celestial-WLAN" = {
      psk = "celestial bodies meaning beautiful eyes";
    };
  };

  networking.interfaces.enp3s0 = {
    ipv4.addresses = [{
        address = "192.168.10.1";
        prefixLength = 16;
    }];
    # Disable dhcp
    useDHCP = false;
  };

  networking.localCommands = ''
    ip link set enp3s0 up
  '';

  # Force the name to stay the same based on the MAC address
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="<9c:6b:00:03:dc:d3>", NAME="eth-direct"
  '';

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = "0"; # Disable reverse path filtering
    "net.ipv4.conf.default.rp_filter" = "0"; # Disable reverse path filtering for default interface
  };

  networking.firewall.trustedInterfaces = ["enp3s0"];
}
