#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./work OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, nixpkgs, nixpkgs-stable, nix-index-database, home-manager, nur, user, location, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{

  laptop-iapetus = lib.nixosSystem {                                # Laptop profile
    # Ideapad S540
    inherit system;
    specialArgs = {
      inherit inputs stable user location;
    };
    modules = [
      nur.nixosModules.nur
      { nixpkgs.overlays = [ nur.overlay ]; }
      ./laptop-iapetus
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs stable user location;
        };
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
            nix-index-database.hmModules.nix-index
            { nixpkgs.overlays = [ nur.overlay ]; }
            (import ./home.nix)
            (import ./laptop-iapetus/home.nix)
          ];
        };
      }
    ];
  };

  desktop-clotho = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs stable system user location;
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      { nixpkgs.overlays = [ nur.overlay ]; }
      ./desktop-clotho
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs stable user location;
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
            nix-index-database.hmModules.nix-index
            { nixpkgs.overlays = [ nur.overlay ]; }
            ./home.nix
            ./desktop-clotho/home.nix
          ];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = {
      inherit inputs stable user location;
    };
    modules = [
      nur.nixosModules.nur
      { nixpkgs.overlays = [ nur.overlay ]; }
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs stable user location;
        };
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
            nix-index-database.hmModules.nix-index
            { nixpkgs.overlays = [ nur.overlay ]; }
            (import ./home.nix)
            (import ./vm/home.nix)
          ];
        };
      }
    ];
  };
}
