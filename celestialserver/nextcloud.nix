{ config, pkgs, ... }:
{
  fileSystems."/var/lib/nextcloud/data" = {
    device = "/mnt/data/nextcloud";
    options = [ "bind" ];
    fsType = "none";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/data/nextcloud 0750 nextcloud nextcloud - -"
  ];

  systemd.services.nextcloud-setup.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.nextcloud-cron.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.phpfpm-nextcloud.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.redis-nextcloud.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.nextcloud-update-apps.requires = [ "var-lib-nextcloud-data.mount" ];
  systemd.services.nextcloud-update-db.requires = [ "var-lib-nextcloud-data.mount" ];

  users.users.nextcloud.extraGroups = [ "nextcloud" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud35;
    hostName = "celestialserver.localdeer";

    config = {
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
        "nextcloud.localdeer"
      ];
    };
  };
}
