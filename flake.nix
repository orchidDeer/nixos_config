# Flakes are pretty much programming language packages for nix.
# They have inputs (other flakes they depend on),
# and outputs (an attribute set that depends on the inputs,
# with special names for specific functionality like exposing nixos configurations)
#
# The contents of this file has to be saved as `flake.nix` in the root of your repo to work.

{
  description = "My NixOS configuration";

  # inputs are defined in the input attribute set, and you almost always want to depend on at least nixpkgs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs is a function taking in the inputs as an attribute set and returning an attribute set with specific attributes
  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations.celestia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # or your target system
        modules = [
          ./celestia/configuration.nix
        ];
        # specialArgs is optional, but I like passing all flake inputs here.
        # specialArgs can be referenced in nixos modules at the top of each file, the same way you refer to `pkgs`: `{ pkgs, inputs, ... }:``
        specialArgs = {
          inherit inputs; # `inherit inputs` is shorthand for `inputs = inputs`.
        };
      };

      # `nixosConfigurations` is a special output name recognized by `nixos-rebuild`.
      # Using this, you can do `nixos-rebuild switch --flake /path/to/flake/directory#servername`
      # or even `nixos-rebuild switch --flake github:owner/repo#servername` (or git+https://customgitserver.org/owner/repo#server)
      nixosConfigurations.clestialserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # or your target system
        modules = [
          ./configuration.nix
        ];
        # specialArgs is optional, but I like passing all flake inputs here.
        # specialArgs can be referenced in nixos modules at the top of each file, the same way you refer to `pkgs`: `{ pkgs, inputs, ... }:``
        specialArgs = {
          inherit inputs; # `inherit inputs` is shorthand for `inputs = inputs`.
        };
      };
    };
}

# Flakes can do a lot more than just this, but these are the basics.
# They are documented here https://wiki.nixos.org/wiki/Flakes (and tbh the wiki probably says most of what i just wrote)
