{
  # Configure Actual Budget to listen only on localhost
  services.actual = {
    enable = true;
    settings = {
      port = 5006;
      hostname = "127.0.0.1";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
