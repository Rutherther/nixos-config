#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/gnome/home.nix  #Window Manager
      ../../modules/editors/emacs/home.nix  #Doom emacs
    ];

  home = {                                  # Specific packages for desktop
    packages = with pkgs; [
    ];
  };
}
