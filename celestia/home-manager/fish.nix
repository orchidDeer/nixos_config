{
  programs.fish = {
    enable = true;

    shellAliases = {
      nixos-rebuild-celestialserver = "nixos-rebuild switch --flake .#celestialserver --target-host juna@celestialserver.localdeer --build-host juna@celestialserver.localdeer --sudo --ask-sudo-password";
      nixos-rebuild-celestia = "sudo nixos-rebuild switch --flake .#celestia";
      nixos-rebuild-remote-celestia = "sudo nixos-rebuild switch --build-host juna@celestialserver.localdeer --flake .#celestia";
      sopsenv = "sops --input-type binary --output-type binary";
    };
  };
}
