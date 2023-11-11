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

{ inputs, config, pkgs, lib, user, ... }:

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

  networking.hostName = "laptop-iapetus";

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        editor = false;                     # Better security, disallows passing /bin/sh to start as root
        configurationLimit = 5;
      };
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

  programs = {
    xss-lock = let
    xsecurelock = (pkgs.xsecurelock.overrideAttrs(attrs: {
          postInstall = attrs.postInstall or "" + ''
            wrapProgram $out/bin/xsecurelock --set XSECURELOCK_COMPOSITE_OBSCURER 0
          '';
        }));
    in {
      enable = true;
      lockerCommand = "${xsecurelock}/bin/xsecurelock";
    };
  };

  services = {
    tlp.enable = true;                      # TLP and auto-cpufreq for power management
    logind.lidSwitch = "lock";           # lock on lid close
    auto-cpufreq.enable = true;
    blueman.enable = true;

    xserver.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
      };
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.splix
        pkgs.samsung-unified-linux-driver
      ];
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${inputs.semi-secrets.wg.lan.laptopIp}/32" ];
    };
  };

  nix = {
    settings = {
      substituters = [
        "desktop.local"
      ];
      trusted-substituters = [
        "desktop.local:3XEsbBcVpKcx0ViXnZwcagllTUazVnc+Rzx5DKUU1Rs="
      ];
    };
  };
}
