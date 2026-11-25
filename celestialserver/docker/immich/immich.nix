{
  # docker-compose.yml uses `env_file: - .env`, resolved relative to
  # /etc/compose/immich, where compose-stacks.nix links the decrypted secret.
  local.composeStacks.immich = {
    files = {
      "docker-compose.yml" = ./docker-compose.yml;
      "hwaccel.ml.yml" = ./hwaccel.ml.yml;
      "hwaccel.transcoding.yml" = ./hwaccel.transcoding.yml;
    };
    envFile = ./secrets.env;
  };

  services.caddy.virtualHosts."immich.localdeer" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:2283
    '';
  };
}
