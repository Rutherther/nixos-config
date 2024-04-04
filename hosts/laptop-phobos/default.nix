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

{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/dm/gdm.nix
    ../../modules/desktop/qtile/default.nix
    ../../modules/desktop/gnome/default.nix
    ../../modules/hardware
    ../../modules/desktop/virtualisation
    ./udev.nix
  ];

  networking.hostName = "laptop-phobos";

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    # Secure boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = lib.mkForce false; # lanzaboote is used instead
        editor = false;                     # Better security, disallows passing /bin/sh to start as root
        configurationLimit = 5;
      };
      timeout = 1;                          # Grub auto select time
    };

    initrd.systemd.enable = true;
    initrd.luks.devices = {
      "crypted-linux-root" = {
        device = "/dev/disk/by-label/crypted-linux-root";
        allowDiscards = true;

        keyFileSize = 256;
        keyFile = "/dev/disk/by-id/usb-VendorCo_ProductCode_92073160DC061126104-0:0";
        keyFileTimeout = 10;
      };
    };
  };

  security.pam.services.login.fprintAuth = false;
  security.pam.services.sddm.fprintAuth = false;
  security.pam.services.sddm-greeter.fprintAuth = false;
  # services.fprintd.enable = true;

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
    logind.lidSwitch = "suspend";           # suspend on lid close

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

  # Wireguard
  wg.ip = "192.168.32.25";
}
