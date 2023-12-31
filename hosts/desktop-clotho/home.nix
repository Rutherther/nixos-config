#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ ./home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ home.nix
#

{ pkgs, lib, config, stable, ... }:

{
  imports =
    [
      ../../modules/desktop/qtile/home.nix  # Window Manager
      (import ../../modules/programs/fpga/vivado/home.nix {
        inherit pkgs lib config stable;
        vivadoPath = "/data/Linux/fpga/apps/xilinx/Vivado/2023.1/bin/vivado";
      })
    ];

  home = {                                # Specific packages for desktop
    packages = [
      pkgs.distrobox
    ];
  };
}
