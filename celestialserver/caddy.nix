{
  services.nginx.virtualHosts."celestialserver.orchiddeer.de" = {
    listen = [
      {
        addr = "localhost";
        port = 42633;
      }
    ];
  };

  services.caddy = {
    enable = true;
    email = "caddy@orchiddeer.de";

    virtualHosts."nextcloud.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:42633
      '';
    };

    virtualHosts."jellyfin.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };

    virtualHosts."jellyseerr.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:5055
      '';
    };

    virtualHosts."qbit.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };

    virtualHosts."immich.orchiddeer.de" = {
      extraConfig = ''
        reverse_proxy localhost:2283
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
