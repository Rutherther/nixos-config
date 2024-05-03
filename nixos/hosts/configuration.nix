{ stable, pkgs, inputs, config, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs stable;
  };
  home-manager.users.${config.nixos-config.defaultUser} = {
    imports = [
      inputs.nix-index-database.hmModules.nix-index
      ./${config.networking.hostName}/home.nix
      ../../home
      {
        inherit (config) nixos-config;
      }
    ];
  };

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  hardware.pulseaudio.enable = false;

  users.users.${config.nixos-config.defaultUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" "video" "audio" "camera"
      "networkmanager" "lp" "scanner"
      "plex" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  networking.networkmanager.enable = true;
  programs.command-not-found.enable = false;
  security.sudo.wheelNeedsPassword = true;
  programs.dconf.enable = true;
  services.udisks2.enable = true;

  time.timeZone = "Europe/Prague";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
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

  services.xserver.serverFlagsSection = ''
    Option "BlankTime" "15"
    Option "StandbyTime" "30"
    Option "SuspendTime" "30"
    Option "OffTime" "60"
  '';

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

  systemd.network = {
    wait-online.enable = false;
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

      flake-registry = ""; # Do not pollute with external flake registry

      auto-optimise-store = true;           # Optimise syslinks
      substituters = [
        "https://cache.nixos.org"
      ];

      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" ];
    };

    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system = {
    stateVersion = "23.05";
  };

  virtualisation.vmVariant = {
    users.users.ruther.password = "vm";
    users.users.root.password = "vm";
  };
}
