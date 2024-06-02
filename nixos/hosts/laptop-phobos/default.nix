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

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixos-config.isLaptop = true;
  profiles.virtualisation.enable = true;
  profiles.desktop.qtile.enable = true;
  profiles.vpn.enable = true;
  profiles.sync.enable = true;
  profiles.development = {
    enable = true;

    fpga.cables = [ "vivado" "ise" ];
    mcu.cables = [ "tiva-c" "st-link" "trezor" ];
  };

  networking.hostName = "laptop-phobos";

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "amdgpu" ];

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
      timeout = 0;
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

  # TODO under profiles
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [ "" "@${pkgs.util-linux}/sbin/agetty agetty --login-program '${config.services.getty.loginProgram}' --login-options '-p -- ruther' --skip-login --noclear --keep-baud %I 115200,38400,9600 $TERM" ];
  };

  # TODO under qtile
  hardware = {                              # No xbacklight, this is the alterantive
    brillo.enable = true;
  };

  # TODO under qtile
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

  systemd.user.services.xss-lock = {
    partOf = lib.mkForce [ "xorg-wm-session.target" ];
    wantedBy = lib.mkForce [ "xorg-wm-session.target" ];
  };

  programs.steam = {
    enable = true;
  };

  systemd.services."NetworkManager-wait-online".enable = false;

  services = {
    power-profiles-daemon.enable = true;
    logind.lidSwitch = "suspend";                # suspend on lid close
    logind.lidSwitchDocked = "ignore";           # suspend on lid close
    # TODO: this is here because when the laptop is docked, and Wayland/X session
    # ends, it is for a brief moment not in docked state, which suspends it.
    # Since it is also on external power, this effectively means it will be ignored
    logind.lidSwitchExternalPower = "ignore";    # suspend on lid close
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
      };
    };

    xserver = {
      videoDrivers = [ "amdgpu" ];
      deviceSection = ''Option "TearFree" "true"'';
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.splix
        pkgs.samsung-unified-linux-driver
      ];
    };
  };

  # TODO put these in relevant files instead
  security.pam.services.waylock = {};
  security.pam.services.swaylock = {};

  # Wireguard
  profiles.vpn.lanIp = "192.168.32.25";
}
