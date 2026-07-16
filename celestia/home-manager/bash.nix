{
  programs.bash = {
    enable = true;

    shellAliases = {
      nixos-rebuild-celestialserver = "env NIX_SSHOPTS='-p 5432' nixos-rebuild switch --flake .#celestialserver --target-host juna@celestialserver.localdeer --build-host juna@celestialserver.localdeer --sudo --ask-sudo-password";
      nixos-rebuild-celestia = "sudo nixos-rebuild switch --flake .#celestia";
      nixos-rebuild-remote-celestia = "sudo nixos-rebuild switch --build-host juna@celestialserver.localdeer --flake .#celestia";
    };
  };
}
