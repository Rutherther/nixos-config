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
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                     # Default Stable Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
      dslr.url = "github:nixos/nixpkgs/nixos-22.11";                        # Quick fix

      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {                                                               # NUR Packages
        url = "github:nix-community/NUR";                                   # Add "nur.nixosModules.nur" to the host modules
      };

      nixgl = {                                                             # OpenGL
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      doom-emacs = {                                                        # Nix-community Doom Emacs
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, nur, nixgl, dslr, doom-emacs, hyprland, plasma-manager, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      user = "ruther";
      location = "$HOME/.setup";
    in                                                                      # Use above variables in ...
    {
      nixosConfigurations = (                                               # NixOS configurations
        import ./hosts {                                                    # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nur user location dslr doom-emacs hyprland plasma-manager;   # Also inherit home-manager so it does not need to be defined here.
        }
      );

      homeConfigurations = (                                                # Non-NixOS configurations
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nixgl user;
        }
      );
    };
}
