{ config, pkgs, ... }:
{
  sops.secrets.couchdb_password = {
    sopsFile = ./couchdb_adminpass;
    owner = "couchdb";
    format = "binary";
  };

  # new: the vault's end-to-end encryption passphrase (different from the
  # couchdb login password above)
  sops.secrets.livesync_passphrase = {
    sopsFile = ./livesync_passphrase;
    format = "binary";
  };

  sops.templates."couchdb-admin.ini" = {
    content = ''
      [admins]
      juna = ${config.sops.placeholder.couchdb_password}
    '';
    owner = "couchdb";
  };

  sops.templates."livesync-server.env" = {
    content = ''
      hostname=https://couchdb.localdeer
      database=junaobsidian
      username=juna
      password=${config.sops.placeholder.couchdb_password}
      passphrase=${config.sops.placeholder.livesync_passphrase}
    '';
  };

  services.couchdb = {
    enable = true;
    bindAddress = "127.0.0.1";
    extraConfigFiles = [ config.sops.templates."couchdb-admin.ini".path ];
  };

  services.caddy.virtualHosts."couchdb.localdeer" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:5984
      tls internal
    '';
  };

  # Setup new devices
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "livesync-setup-uri";
      runtimeInputs = [
        pkgs.deno
        pkgs.qrencode
      ];
      text = ''
        CONF_FILE="${config.sops.templates."livesync-server.env".path}"
        set -a
        # shellcheck disable=SC1090
        source "$CONF_FILE"
        set +a

        output=$(deno run -A https://raw.githubusercontent.com/vrtmrz/obsidian-livesync/main/utils/flyio/generate_setupuri.ts)
        echo "$output"

        uri=$(echo "$output" | grep -o 'obsidian://setuplivesync[^[:space:]]*' || true)
        if [[ -n "$uri" ]]; then
          echo
          echo "Scan this on the new device:"
          qrencode -t ANSIUTF8 "$uri"
        fi
      '';
    })
  ];
}
