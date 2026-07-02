{ config, ... }:
{
  sops.secrets.nextcloud_adminpass = {
    sopsFile = ./nextcloud_adminpass;
    format = "binary";
  };

  fileSystems."/var/lib/nextcloud/data" = {
    device = "/mnt/data/nextcloud";
    options = [ "bind" ];
    fsType = "ext4";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/data/nextcloud 0750 nextcloud nextcloud - -"
  ];

  systemd.services.nextcloud-setup.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.nextcloud-cron.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.phpfm-nextcloud.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.redis-nextcloud.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.nextcloud-update-apps.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.nextcloud-update-db.requires = [ "var-lib-nextcloud-data.mount" ];

  users.users.nextcloud.extraGroups = [ "nextcloud" ];

  services.nextcloud = {
    enable = true;
    hostName = "celestialserver.orchiddeer.de";

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
        "nextcloud.orchiddeer.de"
      ];
    };
  };

  # Open firewall for HTTP/HTTPS
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
