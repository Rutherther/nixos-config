#
# These are the diffent profiles that can be used when building Nix.
#
# flake.nix
#   └─ ./nix
#       └─ default.nix *
#

{ lib, inputs, nixpkgs, home-manager, nixgl, user, location, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  pacman = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    extraSpecialArgs = { inherit inputs nixgl user location; };
    modules = [
      ./pacman.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "23.05";
        };
      }
    ];
  };
}
