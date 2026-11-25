{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      sops-nix,
      nur,
      ...
    }@inputs:
    let
      # Package set from the stable channel, for packages that are broken or
      # not cached on unstable.
      stableFor = prev: nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system};

      mkHost =
        name: overlays:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
            ./common.nix
            ./${name}/configuration.nix
            { nixpkgs.overlays = overlays; }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations.celestia = mkHost "celestia" [
        (final: prev: {
          # Fetch the pre-compiled moonlight from the stable cache
          moonlight-qt = (stableFor prev).moonlight-qt;
        })
      ];

      nixosConfigurations.celestialserver = mkHost "celestialserver" [
        (final: prev: {
          pihole-ftl = (stableFor prev).pihole-ftl;
          open-webui =
            (import nixpkgs-stable {
              system = prev.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            }).open-webui;
        })
      ];
    };
}
