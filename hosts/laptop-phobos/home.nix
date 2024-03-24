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

  systemd.user.services.cbatticon = lib.mkIf config.services.cbatticon.enable {
    Unit = {
      After = lib.mkForce [];
      PartOf = lib.mkForce [ "qtile-services.target" ];
    };
    Install.WantedBy = lib.mkForce [ "qtile-services.target" ];
  };

  systemd.user.services.network-manager-applet = lib.mkIf config.services.network-manager-applet.enable {
    Unit = {
      After = lib.mkForce [];
      PartOf = lib.mkForce [ "qtile-services.target" ];
    };
    Install.WantedBy = lib.mkForce [ "qtile-services.target" ];
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
