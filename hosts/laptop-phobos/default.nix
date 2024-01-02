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

let
    trezor-udev-rules = pkgs.writeTextFile {
      name = "trezor-udev-rules";
      destination = "/etc/udev/rules.d/100-trezor.rules";
      text = ''
        # Trezor: The Original Hardware Wallet
        # https://trezor.io/
        #
        # Put this file into /etc/udev/rules.d
        #
        # If you are creating a distribution package,
        # put this into /usr/lib/udev/rules.d or /lib/udev/rules.d
        # depending on your distribution

        # Trezor
        SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

        # Trezor v2
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c0", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    ti-udev-rules = pkgs.writeTextFile {
      name = "tiva-c-launchpad-udev-rules";
      destination = "/etc/udev/rules.d/100-tiva-c.rules";
      text = ''
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0403",ATTRS{idProduct}=="a6d0",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0403",ATTRS{idProduct}=="a6d1",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0403",ATTRS{idProduct}=="6010",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1cbe",ATTRS{idProduct}=="00fd",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1cbe",ATTRS{idProduct}=="00ff",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef1",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef2",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef3",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef4",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="f432",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0d28",ATTRS{idProduct}=="0204",MODE:="600", TAG+="uaccess"
        KERNEL=="hidraw*",ATTRS{busnum}=="*",ATTRS{idVendor}=="0d28",ATTRS{idProduct}=="0204",MODE:="600", TAG+="uaccess"
        ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef0",ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTRS{idVendor}=="0c55",ATTRS{idProduct}=="0220",ENV{ID_MM_DEVICE_IGNORE}="1"
        KERNEL=="ttyACM[0-9]*",MODE:="0600", TAG+="uaccess"
      '';
    };

    stlink-udev-rules = pkgs.writeTextFile {
      name = "stlink-udev-rules";
      destination ="/etc/udev/rules.d/100-stlink.rules";
      text = ''
        # ST-LINK V2
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv2_%n"

        # ST-LINK V2.1
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv2-1_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv2-1_%n"

        # ST-LINK V3
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3loader_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3_%n"
      '';
    };
in {
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    #[(import ../../modules/desktop/dm/sddm.nix)] ++       # Desktop manager
    [(import ../../modules/desktop/dm/gdm.nix)] ++       # Desktop manager
    [(import ../../modules/desktop/qtile/default.nix)] ++ # Window Manager
    [(import ../../modules/desktop/gnome/default.nix)] ++ # Window Manager
    (import ../../modules/hardware) ++
    [(import ../../modules/hardware/rocm)] ++
    [(import ../../modules/programs/games.nix)] ++
    (import ../../modules/desktop/virtualisation);

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
        keyFileTimeout = 5;
      };
    };
  };

  security.pam.services.login.fprintAuth = false;
  security.pam.services.sddm.fprintAuth = false;
  security.pam.services.sddm-greeter.fprintAuth = false;
  services.fprintd.enable = true;

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

    udev = {
      packages = [
        inputs.nix-fpga-tools.packages.x86_64-linux.ise-udev-rules
        inputs.nix-fpga-tools.packages.x86_64-linux.vivado-udev-rules
        trezor-udev-rules
        ti-udev-rules
        stlink-udev-rules
      ];
    };

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
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${inputs.semi-secrets.wg.lan.laptopPhobosIp}/32" ];
    };
  };
}
