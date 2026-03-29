{
  networking.hostName = "celestia";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.networkmanager.ensureProfiles.profiles = {
    "Direct-Server-Link" = {
      connection = {
        id = "Direct-Server-Link";
        type = "ethernet";
        autoconnect = true;
      };
      match = {
        # Bind this profile to a specific hardware MAC address
        mac-address = "9c:bf:0d:00:7e:63";
      };
      ipv4 = {
        method = "manual";
        address1 = "192.168.10.150/24";
        routes = "192.168.2.111/24,192.168.10.1";
      };
      ipv6.method = "disabled";
    };
  };
}
