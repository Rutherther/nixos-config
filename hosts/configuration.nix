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

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  hardware.pulseaudio.enable = false;

  users.groups.plugdev.members = [ "${user}" ];
  users.users.${user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" "podman" ];
    shell = pkgs.zsh;                       # Default shell
  };
  programs.zsh.enable = true; # has to be here to set shell to zsh
    # zsh is configured at home-manager level afterwards

  networking.networkmanager.enable = true;

  programs.nm-applet.enable = true;
  systemd.user.services.nm-applet = lib.mkIf config.programs.nm-applet.enable {
    wantedBy = lib.mkForce [ "qtile-services.target" ];
    partOf = lib.mkForce [ "qtile-services.target" ];
  };

  programs.command-not-found.enable = false;

  security.sudo.wheelNeedsPassword = true;
  programs.dconf.enable = true;
  services.udisks2.enable = true;

  time.timeZone = "Europe/Prague";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {                 # Extra locale settings that need to be overwritten
      # LC_TIME = "cs_CZ.UTF-8";
      # LC_MONETARY = "cs_CZ.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";                          # or us/azerty/etc
  };

  security.rtkit.enable = true;
  systemd.services.rtkit-daemon = {
    serviceConfig = {
      LogLevelMax = 4;
      ExecStart = [
        ""
        "${pkgs.rtkit}/libexec/rtkit-daemon --processes-per-user-max=1000 --processes-per-user-max=10000 --actions-per-burst-max=1000 --actions-burst-sec=10 --canary-cheep-msec=30000 --canary-watchdog-msec=60000"
      ];
    };
  };

  security.polkit.enable = true;

  fonts.packages = with pkgs; [                # Fonts
    inter
    ubuntu_font_family
    fira-code
    roboto
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    vistafonts
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
        "Ubuntu"
      ];
    })
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Ubuntu" ];
      sansSerif = [ "Ubuntu" ];
      monospace = [ "Ubuntu Mono" ];
    };
  };

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
      ripgrep
      bat
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

  # services.pipewire.wireplumber.configPackages =
  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.properties = {
  #       ["bluez5.msbc-support"] = true;
  #       ["bluez5.sbc-xq-support"] = true;
  #       ["bluez5.enable-faststream"] = true;
  #       ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag ]";
  #       ["bluez5.hfphsp-backend"] = "hsphfpd";
  #     }
  #   '';
  # };

  systemd.network = {
    wait-online = {
      enable = false;
    };
  };

  nix = {                                   # Nix Package Manager settings
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;
    nixPath = [
      "nixpkgs=flake:nixpkgs"
      "nixpkgs-stable=flake:nixpkgs-stable"
    ];

    settings = {
      connect-timeout = 5;

      flake-registry = builtins.toFile "global-registry.json" ''{"flakes":[],"version":2}'';

      auto-optimise-store = true;           # Optimise syslinks
      substituters = [
        "https://cache.nixos.org"
        "https://rutherther.cachix.org"
      ];
      trusted-public-keys = [
        "rutherther.cachix.org-1:O9st5Dq/VHb0T8+vwZ0aP4sjzzCn7Ry60wSyXaRW7j8="
      ];
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system = {                                # NixOS settings
    stateVersion = "23.05";
  };
}
