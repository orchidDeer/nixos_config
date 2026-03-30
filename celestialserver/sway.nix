{ pkgs, ... }:
{
  # 1. Enable Sway and wayvnc
  programs.sway.enable = true;

  # 2. Define the headless Sway systemd service
  systemd.user.services.sway-headless = {
    description = "Headless Sway Wayland Session";
    documentation = [ "man:sway(5)" ];

    # Ensure it starts after the basic user session is ready
    wantedBy = [ "default.target" ];

    serviceConfig = {
      PassEnvironment = "PATH";
      Type = "simple";
      # Setting environment variables directly in the service
      Environment = [
        "WLR_BACKENDS=headless"
        "WLR_LIBINPUT_NO_DEVICES=1"
        "WLR_DRM_DEVICES=/dev/dri/card1"
        "XDG_SESSION_TYPE=wayland"
        "XDG_CURRENT_DESKTOP=sway"
        "SWAYSOCK=/run/user/1000/sway-ipc.1000.sock"
      ];
      # Use the absolute path from the nix store
      ExecStart = "${pkgs.sway}/bin/sway";
      ExecStartPost = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 5; SWAYSOCK=/run/user/1000/sway-ipc.1000.sock ${pkgs.sway}/bin/swaymsg \"output HEADLESS-1 enable mode 1920x1080@60Hz position 0 0\"'";
      #Restart = "always";
      #RestartSec = "5s";
    };
  };

  # 3. Required: Enable lingering for your user so the service starts at boot
  # Replace 'yourusername' with your actual NixOS username
  users.users.juna.linger = true;

  # 4. Seat management (required for wlroots)
  services.seatd.enable = true;
}
