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

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/gnome/home.nix  # Window Manager
    ];

  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      ansible           # Automation
      sshpass           # Ansible Dependency
      hugo              # Static Website Builder

      # Dependencies
      ispell            # Emacs spelling

      #steam            # Game Launcher
    ];
  };
}
