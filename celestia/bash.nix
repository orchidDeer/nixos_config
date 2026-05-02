{
  programs.bash = {
    enable = true;

    shellAliases = {
      nixos-rebuild-celestialserver = "env NIX_SSHOPTS='-p 5432' nixos-rebuild switch --flake .#celestialserver --target-host juna@192.168.2.111 --use-remote-sudo --ask-sudo-password";
      nixos-rebuild-celestia = "sudo nixos-rebuild switch --flake .#celestia";
    };
  };
}
