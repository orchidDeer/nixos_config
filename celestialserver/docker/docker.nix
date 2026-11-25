{
  imports = [
    ./compose-stacks.nix
    ./docker-tools.nix
    ./immich/immich.nix
    ./steam-headless/steam-headless.nix
    ./jellyfin/jellyfin.nix
  ];

  hardware.nvidia-container-toolkit.enable = true;
}
