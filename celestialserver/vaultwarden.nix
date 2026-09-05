{
  config,
  ...
}:
{
  sops.secrets.smtp_password = {
    sopsFile = ./smtp_password;
    format = "binary";
  };

  sops.secrets.vaultwarden_admin_token = {
    sopsFile = ./vaultwarden_admin_token;
    format = "binary";
  };

  sops.templates."vaultwarden.env" = {
    # The placeholder pulls the content of your binary secret
    content = ''
      ADMIN_TOKEN=${config.sops.placeholder.vaultwarden_admin_token}
      SMTP_PASSWORD=${config.sops.placeholder.smtp_password}
    '';
    # Ensure the vaultwarden user can read the generated file
    owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    environmentFile = config.sops.templates."vaultwarden.env".path;

    config = {
      # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
      DOMAIN = "https://vaultwarden.orchiddeer.de";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      # This example assumes a mailserver running on localhost,
      # thus without transport encryption.
      # If you use an external mail server, follow:
      #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
      SMTP_HOST = "w020899d.kasserver.com";
      SMTP_PORT = 465;
      SMTP_EXPLICIT_TLS = true;
      SMTP_USERNAME = "juna@orchiddeer.de";

      SMTP_FROM = "admin@orchiddeer.de";
      SMTP_FROM_NAME = "orchiddeer.de Vaultwarden server";
    };
  };
}
