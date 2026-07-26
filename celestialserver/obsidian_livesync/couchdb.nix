{
  config,
  lib,
  pkgs,
  ...
}:
let
  vaults = {
    juna = {
      database = "junaobsidian";
      sopsFile = ./juna_livesync_passphrase;
    };
    share = {
      database = "shareobsidian";
      sopsFile = ./share_livesync_passphrase;
    };
    liv = {
      database = "livobsidian";
      sopsFile = ./liv_livesync_passphrase;
    };
  };

  mkSetupScript =
    name: vault:
    pkgs.writeShellApplication {
      name = "livesync-setup-uri-${name}";
      runtimeInputs = [
        pkgs.deno
        pkgs.qrencode
      ];
      text = ''
        CONF_FILE="${config.sops.templates."livesync-server-${name}.env".path}"
        set -a
        # shellcheck disable=SC1090
        source "$CONF_FILE"
        set +a
        output=$(deno run -A https://raw.githubusercontent.com/vrtmrz/obsidian-livesync/main/utils/flyio/generate_setupuri.ts)
        echo "$output"
        uri=$(echo "$output" | grep -o 'obsidian://setuplivesync[^[:space:]]*' || true)
        if [[ -n "$uri" ]]; then
          echo
          echo "Scan this on the new device (${name}):"
          qrencode -t ANSIUTF8 "$uri"
        fi
      '';
    };
in
{
  sops.secrets = {
    couchdb_password = {
      sopsFile = ./couchdb_adminpass;
      owner = "couchdb";
      format = "binary";
    };
  }
  // lib.mapAttrs' (
    name: vault:
    lib.nameValuePair "livesync_passphrase_${name}" {
      sopsFile = vault.sopsFile;
      format = "binary";
    }
  ) vaults;

  sops.templates = {
    "couchdb-admin.ini" = {
      content = ''
        [admins]
        juna = ${config.sops.placeholder.couchdb_password}
      '';
      owner = "couchdb";
    };
  }
  // lib.mapAttrs' (
    name: vault:
    lib.nameValuePair "livesync-server-${name}.env" {
      content = ''
        hostname=https://celestialserver.tail1ab1f7.ts.net
        database=${vault.database}
        username=juna
        password=${config.sops.placeholder.couchdb_password}
        passphrase=${config.sops.placeholder."livesync_passphrase_${name}"}
      '';
    }
  ) vaults;

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
  services.caddy.virtualHosts."celestialserver.tail1ab1f7.ts.net" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:5984
      tls /var/lib/tailscale-certs/celestialserver.tail1ab1f7.ts.net.crt /var/lib/tailscale-certs/celestialserver.tail1ab1f7.ts.net.key
    '';
  };

  environment.systemPackages = lib.mapAttrsToList mkSetupScript vaults;
}
