{
  networking.hostName = "celestia";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # This forces your nameservers to the TOP of the list
  # and ignores the ones provided by the router DHCP
  networking.resolvconf.extraOptions = [
    "timeout:1"
    "attempts:1"
  ];
  networking.networkmanager.insertNameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Disable the speedport search domain to stop unnecessary lookups
  networking.search = [ ];

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
        routes = "192.168.2.111/24,192.168.10.1";
        never-default = true;
      };
      ipv6.method = "disabled";
    };
  };
}
