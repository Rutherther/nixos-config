#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./hyprland
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       ├─ ./programs
#       │   └─ games.nix
#       └─ ./hardware
#           └─ default.nix
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/dm/sddm.nix
    ../../modules/desktop/qtile/default.nix
    ../../modules/programs/games.nix
    ../../modules/desktop/virtualisation
    ../../modules/hardware
  ];

  networking.hostName = "desktop-clotho";

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
    initrd.kernelModules = [ "amdgpu" ];        # Video drivers

    loader = {                                  # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5;                 # Limit the amount of configurations
        editor = false;                         # Better security, disallows passing /bin/sh to start as root

        extraEntries = {
          "Windows.conf" = ''
            title "Windows 10"
            efi /EFI/Microsoft/Boot/bootmgfw.efi
          '';
        };
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;                              # Grub auto select time
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      wacomtablet
    ];
  };

  services = {
    xserver.videoDrivers = [ "amdgpu" ];
  };

  wg.ip = "192.168.32.21";

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
    openFirewall = true;
  };
}
