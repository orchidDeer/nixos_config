{ pkgs, ... }:
{
  home.username = "juna";
  home.homeDirectory = "/home/juna";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    btop
    stress-ng
    pciutils
    hashcat
  ];

  imports = [
    ../bash.nix
  ];
}
