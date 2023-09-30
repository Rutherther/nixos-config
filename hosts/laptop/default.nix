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

{ config, pkgs, lib, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/dm/sddm.nix)] ++       # Desktop manager
    [(import ../../modules/desktop/qtile/default.nix)] ++ # Window Manager
    (import ../../modules/hardware) ++
    (import ../../modules/desktop/virtualisation) ++
    [(import ../../modules/programs/fpga/vivado {
      inherit pkgs lib config;
      vivadoPath = "/data/fpga/xilinx/Vivado/2023.1/bin/vivado";
    })];                      # Hardware devices

  networking.hostName = "nixos-laptop";

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
      timeout = 1;                          # Grub auto select time
    };

    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-label/root";
        preLVM = true;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      xorg.xf86videointel
    ];
  };

  networking.networkmanager.enable = true;

  hardware = {                              # No xbacklight, this is the alterantive
    brillo.enable = true;
  };

  services = {
    tlp.enable = true;                      # TLP and auto-cpufreq for power management
    logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
    auto-cpufreq.enable = true;
    blueman.enable = true;

    xserver.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        tappingDragLock = true;
      };
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${inputs.semi-secrets.wg.lan.laptopIp}/32" ];
    };
  };
}
