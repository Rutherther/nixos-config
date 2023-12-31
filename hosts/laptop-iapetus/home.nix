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

{ pkgs, lib, config, stable, ... }:

{
  imports =
    [
      ../../modules/desktop/qtile/home.nix # Window Manager
      (import ../../modules/programs/fpga/vivado/home.nix {
        inherit pkgs lib config stable;
        vivadoPath = "/data/fpga/xilinx/Vivado/2023.1/bin/vivado";
      })
    ];

  home = {                                # Specific packages for laptop
    packages = [
      pkgs.distrobox

      # Power Management
      pkgs.acpi
    ];
  };

  services = {                            # Applets
    network-manager-applet.enable = true; # Network
    cbatticon = {
     enable = true;
     criticalLevelPercent = 10;
     lowLevelPercent = 20;
   };
  };
}
