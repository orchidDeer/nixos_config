{
  networking.hostName = "celestia";
  # Enable networking
  networking.networkmanager.enable = true;

  security.pki.certificateFiles = [ ./celestialserver.crt ];

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
        method = "auto";
        routes = "192.168.2.111/24,200.0.0.1";
        never-default = true;
      };
      ipv6.method = "disabled";
    };
  };
}
