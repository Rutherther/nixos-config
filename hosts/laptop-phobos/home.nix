#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#              └─ home.nix
#

{ pkgs, lib, config, ... }:

{
  imports =
    [
      ../../modules/desktop/qtile/home.nix # Window Manager
      ../../modules/desktop/gnome/home.nix
    ];

  home = {                                # Specific packages for laptop
    packages = [
      pkgs.distrobox

      # Power Management
      pkgs.acpi

      pkgs.easyeffects
    ];
  };

  services = {                            # Applets
    network-manager-applet.enable = true; # Network
    cbatticon = {
     enable = true;
     criticalLevelPercent = 10;
     lowLevelPercent = 20;
    };

    easyeffects = {
      enable = true;
    };
  };
}
