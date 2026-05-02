{ config, ... }:
{
  sops.secrets.nextcloud_adminpass = {
    sopsFile = ./nextcloud_adminpass;
    format = "binary";
  };

  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    config = {
      adminpassFile = config.sops.secrets.nextcloud_adminpass.path;
      adminuser = "admin";
      dbtype = "sqlite";
    };

    https = true;
    configureRedis = true;

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        news
        contacts
        calendar
        tasks
        ;
    };
    extraAppsEnable = true;

    settings = {
      trusted_domains = [
        "192.168.2.111"
        "192.168.10.1"
      ];
    };
  };

  # Open firewall for HTTP/HTTPS
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true; # Enforce HTTPS
    enableACME = true; # Use Let's Encrypt
  };

  # Required for automatic certificate fetching
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "acme@orchiddeer.de";
}
