# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./networking.nix
    ./nvidia.nix
    ./nextcloud.nix
    ./ssh.nix
    ./caddy.nix
    ./vaultwarden.nix
    ./obsidian_livesync/couchdb.nix
    ./tailscale.nix
    ./pihole.nix
    ./actual_budget.nix
    ./docker/docker.nix
    ./inno_pbx.nix
    ./ollama.nix
  ];

  home-manager.users.juna = import ./home.nix;

  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Docker itself is enabled by docker/compose-stacks.nix
  virtualisation.docker.daemon.settings = {
    ipv6 = true;
    # Required to allow Docker to manage IPv6 firewall rules correctly
    "experimental" = true;
    "ip6tables" = true;
  };

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/F8247A272479E950";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "umask=0007"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/eb19c3d7-1888-4255-ba71-0c891f24f3f8";
    fsType = "ext4";
    options = [
      "x-systemd.automount"
      "noauto"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juna = {
    isNormalUser = true;
    description = "juna";
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "input"
      "render"
      "seat"
      "caddy"
    ];
    packages = [ ];
  };

  hardware.enableAllFirmware = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    php
    sops
    iw
    wirelesstools
  ];

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
