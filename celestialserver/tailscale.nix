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
}
