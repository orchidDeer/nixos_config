{
  networking.hostName = "celestia";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.networkmanager.ensureProfiles.profiles = {
    "Direct-Server-Link" = {
      connection = {
        id = "Direct-Server-Link";
        type = "ethernet";
        interface-name = "eth0";
        autoconnect = true;
      };
      ipv4 = {
        method = "manual";
        addresses = "192.168.10.2/16";
        routes = "192.168.2.111/24,192.168.10.1";
      };
      ipv6.method = "disabled";
    };
  };
}
