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
      inherit unstable inputs user location;
      host = {
        hostName = "laptop";
        mainMonitor = "eDP-1";
      };
    };
    modules = [
      nur.nixosModules.nur
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs unstable user location;
          host = {
            hostName = "laptop";
            mainMonitor = "eDP-1";
          };
        };
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
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
      inherit unstable inputs user location;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
        secondMonitor = "Virtual-2";
      };
    };
    modules = [
      nur.nixosModules.nur
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs unstable user location;
          host = {
            hostName = "vm";
            mainMonitor = "Virtual-1";
            secondMonitor = "Virtual-2";
          };
        };
        home-manager.users.${user} = {
          imports = [
            nur.hmModules.nur
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
      host = {
        hostName = "desktop";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "HDMI-A-2";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs unstable user location;
          host = {
            hostName = "desktop";       #For Xorg iGPU  | Hyprland iGPU
            mainMonitor = "HDMI-A-1";   #HDMIA3         | HDMI-A-3
            secondMonitor = "HDMI-A-2"; #DP1            | DP-1
          };
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            nur.nixosModules.nur
            ./home.nix
            ./desktop/home.nix
          ];
        };
      }
    ];
  };
}
