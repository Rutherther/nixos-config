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
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {
        url = "github:nix-community/NUR";
      };

      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nixos-hardware = {
        url = "github:NixOS/nixos-hardware/master";
      };

      wrapper-manager = {
        url = "github:viperML/wrapper-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      lanzaboote = {
        url = "github:nix-community/lanzaboote/v0.3.0";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-fpga-tools = {
        url = "github:Rutherther/nix-fpga";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      noshell = {
        url = "github:Rutherther/noshell/fix/transparent-zeroth-argument";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      schizofox = {
        url = "github:NotAShelf/schizofox";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      spicetify = {
        url = "github:Gerg-L/spicetify-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nix-index-database, home-manager, nur, nixos-hardware, lanzaboote, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      nixosConfigurations = (
        import ./nixos {
          inherit (nixpkgs) lib;
          inherit inputs;
        }
      );

      packages.x86_64-linux = {
        mpris-ctl = pkgs.callPackage ./pkgs/rutherther/mpris-ctl.nix {};
        sequence-detector = pkgs.callPackage ./pkgs/rutherther/sequence-detector.nix {};
        dwlmsg = pkgs.callPackage ./pkgs/dwlmsg.nix {};
        dwlb = pkgs.callPackage ./pkgs/dwlb.nix {};
        dwl = pkgs.callPackage ./pkgs/dwl {};
        tree-sitter-vhdl = pkgs.callPackage ./pkgs/tree-sitter-vhdl.nix {};
      };

      installIsos = import ./nixos/isos {
        inherit (nixpkgs-stable) lib;
        inherit inputs;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          pkgs.nil
        ];
      };
    };
}
