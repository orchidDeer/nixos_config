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

  # SQLite -> PostgreSQL migration, step 1: an empty database for the conversion.
  # Step 2 (on the server, after rebuilding with this):
  #   sudo nextcloud-occ maintenance:mode --on
  #   sudo cp -a /var/lib/nextcloud/data/nextcloud.db /var/lib/nextcloud/data/nextcloud.db.bak
  #   sudo nextcloud-occ db:convert-type --all-apps pgsql nextcloud /run/postgresql nextcloud
  #     (socket + peer auth: just press Enter at the password prompt)
  # Then do step 3 (see services.nextcloud.config), rebuild, and
  #   sudo nextcloud-occ maintenance:mode --off
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  users.users.nextcloud.extraGroups = [ "nextcloud" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud35;
    hostName = "celestialserver.localdeer";

    config = {
      dbtype = "sqlite";
    };

    # SQLite -> PostgreSQL migration, step 3 (after the conversion below):
    # replace the `config` block above and remove `services.postgresql` at the bottom with
    #   config.dbtype = "pgsql";
    #   database.createLocally = true;  # creates the same DB/user and orders setup after postgres

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
