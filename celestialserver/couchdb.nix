{ config, ... }:
{
  sops.secrets.couchdb_password = {
    sopsFile = ./couchdb_adminpass;
    owner = "couchdb";
    format = "binary";
  };

  sops.templates."couchdb-admin.ini" = {
    content = ''
      [admins]
      juna = ${config.sops.placeholder.couchdb_password}
    '';
    owner = "couchdb";
  };

  services.couchdb = {
    enable = true;
    bindAddress = "127.0.0.1";
    extraConfigFiles = [ config.sops.templates."couchdb-admin.ini".path ];
  };
}
