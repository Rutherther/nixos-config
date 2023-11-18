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

{ inputs, pkgs, lib, user, config, location, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/dm/sddm.nix)] ++       # Desktop manager
    [(import ../../modules/desktop/qtile/default.nix)] ++ # Window Manager
    [(import ../../modules/programs/games.nix)] ++
    (import ../../modules/desktop/virtualisation) ++ # Window Manager
    (import ../../modules/hardware) ++                    # Hardware devices
    [(import ../../modules/programs/fpga/vivado {
      inherit pkgs lib config;
      vivadoPath = "/data/Linux/fpga/apps/xilinx/Vivado/2023.1/bin/vivado";
    })];

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

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${inputs.semi-secrets.wg.lan.desktopIp}/32" ];
    };
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
    openFirewall = true;
  };

  # nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
  #   (self: super: {
  #     discord = super.discord.overrideAttrs (
  #       _: { src = builtins.fetchTarball {
  #         url = "https://discord.com/api/download?platform=linux&format=tar.gz";
  #         sha256 = "1z980p3zmwmy29cdz2v8c36ywrybr7saw8n0w7wlb74m63zb9gpi";
  #       };}
  #     );
  #   })
  # ];
}
