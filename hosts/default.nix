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

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, user, location, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{

  laptop = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit inputs unstable user location;
    };
    modules = [
      nur.nixosModules.nur
      { nixpkgs.overlays = [ nur.overlay ]; }
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs unstable user location;
        };
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
            { nixpkgs.overlays = [ nur.overlay ]; }
            (import ./home.nix)
            (import ./laptop/home.nix)
          ];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = {
      inherit inputs unstable user location;
    };
    modules = [
      nur.nixosModules.nur
      { nixpkgs.overlays = [ nur.overlay ]; }
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs unstable user location;
        };
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
            { nixpkgs.overlays = [ nur.overlay ]; }
            (import ./home.nix)
            (import ./vm/home.nix)
          ];
        };
      }
    ];
  };

  desktop = lib.nixosSystem {                               # Desktop profile 
    inherit system;
    specialArgs = {
      inherit inputs unstable system user location;
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      { nixpkgs.overlays = [ nur.overlay ]; }
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs unstable user location;
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
            { nixpkgs.overlays = [ nur.overlay ]; }
            ./home.nix
            ./desktop/home.nix
          ];
        };
      }
    ];
  };
}
