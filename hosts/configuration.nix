#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./editors
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ config, lib, pkgs, inputs, user, ... }:

{
  imports =                                   # Home Manager Modules
    [(import ../modules/desktop)] ++
    (import ../modules/services);

  hardware.pulseaudio.enable = false;

  users.users.${user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    shell = pkgs.zsh;                       # Default shell
  };
  security.sudo.wheelNeedsPassword = true;

  time.timeZone = "Europe/Prague";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {                 # Extra locale settings that need to be overwritten
      LC_TIME = "cs_CZ.UTF-8";
      LC_MONETARY = "cs_CZ.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";                          # or us/azerty/etc
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  fonts.fonts = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [           # Default packages installed system-wide
      alsa-utils
      jq
      killall
      nano
      pciutils
      pulseaudio
      ripgrep
      socat
      usbutils
      wget
    ];
  };

  services = {
    tumbler.enable = true;
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.msbc-support"] = true;
        ["bluez5.sbc-xq-support"] = true;
        ["bluez5.enable-faststream"] = true;
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag ]";
        ["bluez5.hfphsp-backend"] = "hsphfpd";
      }
    '';
  };

  systemd.services."home-manager-${user}".serviceConfig.TimeoutStartSec = lib.mkForce "20m";

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system = {                                # NixOS settings
    stateVersion = "23.05";
  };
}
