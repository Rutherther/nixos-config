#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

      semi-secrets = {
        url = "git+ssh://git@github.com/Rutherther/nixos-semi-secrets";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {                                                               # NUR Packages
        url = "github:nix-community/NUR";                                   # Add "nur.nixosModules.nur" to the host modules
      };

      nixgl = {                                                             # OpenGL
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-vscode-extensions = {
        url = "github:nix-community/nix-vscode-extensions";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nixos-hardware = {
        url = "github:NixOS/nixos-hardware/master";
      };

      lanzaboote = {
        url = "github:nix-community/lanzaboote/v0.3.0";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-fpga-tools = {
        url = "github:Rutherther/nix-fpga";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nix-index-database, home-manager, nur, nixgl, nixos-hardware, lanzaboote, ... }:
    let
      user = "ruther";
      location = "$HOME/.setup";

      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable nix-index-database home-manager nur user location;
        }
      );

      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable nix-index-database home-manager nixgl user location;
        }
      );

      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          pkgs.nil
        ];
      };
    };
}
