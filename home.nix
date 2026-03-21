{ config, pkgs, ... }:
{
  home.username = "juna";
  home.homeDirectory = "/home/juna";

  home.stateVersion = "25.11";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo 'Hello, World!'";
    };

    initExtra = ''
      export PS1='[🪷 \[\e[38;5;182m\]\t\[\e[0m\] <\[\e[38;5;189m\]\u\[\e[0m\]@\[\e[38;5;189m\]\h\[\e[0m\]>\[\e[38;5;216m\]$(__git_ps1 " (%s)")\[\e[0m\] \[\e[38;5;217m\]\w\[\e[0m\] 🪷] \n \[\e[38;5;209m\]🍂 ▶ \[\e]0;🪷\a\]\[\e[0m\]'
    '';
  };

  home.packages = with pkgs; [
    thunderbird
    krita
    legcord
    zed-editor
    prismlauncher
  ];
}
