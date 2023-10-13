#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#   └─ ./modules
#       ├─ ./programs
#       │   └─ default.nix
#       └─ ./services
#           └─ default.nix
#

{ config, lib, nixpkgs, stable, pkgs, user, location, ... }:

{ 
  imports =                                   # Home Manager Modules
    (import ../modules/programs/home.nix) ++
    (import ../modules/shell/home.nix) ++
    (import ../modules/editors/home.nix) ++
    (import ../modules/services/home.nix);

  nixpkgs.config.allowUnfree = true;

  xdg = {
    userDirs = let dir = s: "${config.home.homeDirectory}/${s}"; in {
      documents = dir "doc";
      download = dir "download";
      music = dir "music";
      pictures = dir "photos";
      publicShare = dir "public";
      videos = dir "videos";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "zathura.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "x-scheme-handler/file" = "nemo.desktop";
      };
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      gtop              # Resource Manager
      htop              # Resource Manager
      ranger            # File Manager
      cinnamon.nemo     # GUI File Manager
      tldr              # Helper
      lazygit           # Git tool

      # Video/Audio
      feh               # Image Viewer
      mpv               # Media Player
      pavucontrol       # Audio Control
      vlc               # Media Player
      blueman           # Bluetooth manager

      # Apps
      chromium          # Browser

      # File Management
      zathura            # PDF Viewer
      evince            # PDF Viewer
      foliate           # Ebook viewer
      rsync             # Syncer - $ rsync -r dir1/ dir2/
      unzip             # Zip Files
      unrar             # Rar Files
      zip               # Zip

      # General configuration
      alsa-utils	      # Audio Commands
      git               # Repositories
      procps            # Stop Applications
      pipewire          # Sound
      wacomtablet       # Wacom Tablet
      wget              # Downloader
      #
      # General home-manager
      alacritty         # Terminal Emulator
      vim               # Text Editor
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input Viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen Settings
      #
      # Xorg home-manager
      #
      # Desktop
      discord           # Chat
      telegram-desktop  # Chat
      cinny-desktop     # Chat
      ffmpeg           # Video Support (dslr)

      spotify
      stable.obsidian        # Text Editor
    ];

    file.".config/wall".source = ../modules/themes/wall;

    pointerCursor = {                         # This will set cursor system-wide so applications can not choose their own
      gtk.enable = true;
      #name = "Dracula-cursors";
      name = "Catppuccin-Mocha-Dark-Cursors";
      #package = pkgs.dracula-theme;
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };
    stateVersion = "23.05";
  };

  programs.command-not-found.enable = true;

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "compact";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };                                        # Cursor is declared under home.pointerCursor
  };

  systemd.user.targets.tray = {               # Tray.target can not be found when xsession is not enabled. This fixes the issue.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
