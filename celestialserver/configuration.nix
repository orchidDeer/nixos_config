# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./networking.nix
    ./nvidia.nix
    ./nextcloud.nix
    ./ssh.nix
    ./caddy.nix
    ./caddy_jellyfin.nix
    ./vaultwarden.nix
    ./couchdb.nix
    ./tailscale.nix
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.juna = import ./home.nix;

  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      ipv6 = true;
      # Required to allow Docker to manage IPv6 firewall rules correctly
      "experimental" = true;
      "ip6tables" = true;
    };
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

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
    ];
    packages = with pkgs; [ ];
  };

  environment.interactiveShellInit = ''
    source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    docker-compose
    git
    php
    sops
  ];

  # Prevent sleep
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
