{ pkgs, ... }:
{
  programs.obsidian = {
    enable = true;
    package = pkgs.obsidian;

    vaults."Documents/Obsidian/juna".enable = true;
  };
}
