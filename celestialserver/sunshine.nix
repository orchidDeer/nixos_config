{ pkgs, lib, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  systemd.user.services.sunshine = {
    # Force your environment variables into the existing service
    environment = lib.mkForce {
      XDG_RUNTIME_DIR = "/run/user/1000";
      WAYLAND_DISPLAY = "wayland-1";
      SWAYSOCK = "/run/user/1000/sway-ipc.1000.sock";
    };

    serviceConfig = {
      # Use mkForce and point to the WRAPPER, not the store path
      ExecStart = lib.mkForce "/run/wrappers/bin/sunshine";
    };
  };

  # Ensure the wrapper exists with the right permissions
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+ep";
    source = "${pkgs.sunshine}/bin/sunshine";
  };
}
