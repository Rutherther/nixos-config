#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       ├─ default.nix *
#   │       └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#

{ config, pkgs, lib, ... }:

let
  mkSure = lib.mkOverride 0;
in {
  imports =  [                                  # For now, if applying to other system, swap files
    ./hardware-configuration.nix                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    ../../modules/desktop/dm/sddm.nix           # Desktop Manager
    ../../modules/desktop/qtile/default.nix           # Qtile
  ];

  services.spice-vdagentd.enable = mkSure true;
  services.qemuGuest.enable = true;
  environment.systemPackages = with pkgs; [
    spice-vdagent
    pkgs.xorg.xf86videoqxl
  ];

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                                  # For legacy boot
      grub = {
        enable = true;
        device = "/dev/vda";                    # Name of hard drive (can also be vda)
      };
      timeout = 1;                              # Grub auto select timeout
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${inputs.semi-secrets.wg.lan.laptopIp}/32" ];
    };
  };

  services = {
    xserver = {                                 
      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1920; y = 1080; }
      ];
    };
  };
}
