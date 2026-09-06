{ pkgs, ... }:
{
  imports = [
    ./docker-tools.nix
    ./immich/immich.nix
    ./steam-headless/steam-headless.nix
    ./jellyfin/jellyfin.nix
  ];

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.package = pkgs.docker;
}
