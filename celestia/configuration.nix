# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./hyprland.nix
    ./sddm.nix
    ./tailscale.nix
    ./networking.nix
    ./pipewire.nix
    ./bluetooth.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a7bd9db4-4f79-4b84-a32b-effa485bd4e0".device =
    "/dev/disk/by-uuid/a7bd9db4-4f79-4b84-a32b-effa485bd4e0";

  # Enable networking
  networking.networkmanager.enable = true;

  programs.steam.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."juna" = {
    isNormalUser = true;
    description = "Juna Celestia Knop";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "audio"
      "adbusers"
      "mount"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    sops
    kitty
    android-tools
    gsettings-desktop-schemas
    glib
  ];
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Home manager
  home-manager.users.juna = {
    imports = [
      ./home-manager/home.nix
      inputs.walker.homeManagerModules.default
    ];
  };

  #virtualisation.vmware.host.enable = true;

  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  boot.initrd.kernelModules = [ "amdgpu" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
