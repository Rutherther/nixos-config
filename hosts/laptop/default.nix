#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./bspwm
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ docker.nix
#       └─ ./hardware
#           └─ default.nix
#

{ config, pkgs, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/dm/sddm.nix)] ++       # Desktop manager
    [(import ../../modules/desktop/qtile/default.nix)] ++ # Window Manager
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {                              # Most of grub is set up for dual boot
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;                 # Find all boot options
        configurationLimit = 2;
      };
      timeout = 1;                          # Grub auto select time
    };
  };

  environment = {
    systemPackages = with pkgs; [
      xorg.xf86videointel
    ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    light.enable = true;
  };

  services = {
    tlp.enable = true;                      # TLP and auto-cpufreq for power management
    logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
    auto-cpufreq.enable = true;
    blueman.enable = true;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${inputs.semi-secrets.wg.lan.laptopIp}/32" ];
    };
  };
}
