{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/dm/sddm.nix
    ../../modules/desktop/qtile/default.nix
    ../../modules/hwardware
    ../../modules/desktop/virtualisation
  ];

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
    systemPackages = [
      pkgs.xorg.xf86videointel
    ];
  };


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

  systemd.user.services.xss-lock = {
    partOf = lib.mkForce [ "xorg-wm-session.target" ];
    wantedBy = lib.mkForce [ "xorg-wm-session.target" ];
  };

  services = {
    tlp.enable = true;                      # TLP and auto-cpufreq for power management
    logind.lidSwitch = "lock";           # lock on lid close
    auto-cpufreq.enable = true;
    blueman.enable = true;

    libinput = {
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

  wg.ip = "192.168.32.22";
}
