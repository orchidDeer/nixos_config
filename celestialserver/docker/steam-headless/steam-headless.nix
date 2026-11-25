{
  local.composeStacks.steam-headless = {
    files."docker-compose.yml" = ./docker-compose.yml;
    envFile = ./secrets.env;
  };

  services.caddy.virtualHosts."sunshine.localdeer" = {
    extraConfig = ''
      reverse_proxy https://127.0.0.1:47990 {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };
}
