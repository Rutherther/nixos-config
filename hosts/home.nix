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

{ config, lib, pkgs, unstable, user, location, ... }:

{ 
  imports =                                   # Home Manager Modules
    (import ../modules/programs/home.nix) ++
    (import ../modules/shell/home.nix) ++
    (import ../modules/editors/home.nix) ++
    (import ../modules/services/home.nix);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      gtop              # Resource Manager
      htop              # Resource Manager
      ranger            # File Manager
      tldr              # Helper
      lazygit           # Git tool

      # Video/Audio
      feh               # Image Viewer
      mpv               # Media Player
      pavucontrol       # Audio Control
      vlc               # Media Player

      # Apps
      firefox           # Browser
      chromium          # Browser

      # File Management
      zathura            # PDF Viewer
      evince            # PDF Viewer
      rsync             # Syncer - $ rsync -r dir1/ dir2/
      unzip             # Zip Files
      unrar             # Rar Files
      zip               # Zip

      # General configuration
      alsa-utils	      # Audio Commands
      git               # Repositories
      #jq		# JSON processor
      procps            # Stop Applications
      #pciutils         # Computer Utility Info
      pipewire          # Sound
      #usbutils         # USB Utility Info
      wacomtablet       # Wacom Tablet
      wget              # Downloader
      #socat		# Data Transfer
      #thunar           # File Manager
      #zsh              # Shell
      #
      # General home-manager
      alacritty         # Terminal Emulator
      #dunst            # Notifications
      #libnotify        # Dependency for Dunst
      #neovim           # Text Editor
      #rofi             # Menu
      #rofi-power-menu  # Power Menu
      #udiskie          # Auto Mounting
      vim               # Text Editor
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input Viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen Settings
      #xterm            # Terminal
      #
      # Xorg home-manager
      flameshot         # Screenshot
      picom             # Compositer
      #
      # Wayland configuration
      #autotiling       # Tiling Script
      #eww-wayland	# Bar
      #grim             # Image Grabber
      #slurp            # Region Selector
      #swappy           # Screenshot Editor
      #swayidle         # Idle Management Daemon
      #waybar           # Bar
      #wev              # Input Viewer
      #wl-clipboard     # Console Clipboard
      #wlr-randr        # Screen Settings
      #xwayland         # X for Wayland
      #
      # Wayland home-manager
      #pamixer          # Pulse Audio Mixer
      #swaylock-fancy   # Screen Locker
      #
      # Desktop
      #ansible          # Automation
      blueman           # Bluetooth
      #deluge           # Torrents
      discord           # Chat
      telegram-desktop  # Chat
      unstable.cinny-desktop     # Chat
      ffmpeg           # Video Support (dslr)
      #gmtp             # Mount MTP (GoPro)
      #gphoto2          # Digital Photography
      #handbrake        # Encoder
      #heroic           # Game Launcher
      #hugo             # Static Website Builder
      #lutris           # Game Launcher
      #mkvtoolnix       # Matroska Tool
      #nvtop            # Videocard Top
      #plex-media-player# Media Player
      #prismlauncher    # MC Launcher
      #steam            # Games
      #simple-scan      # Scanning
      #sshpass          # Ansible dependency
      # 
      # Laptop
      #cbatticon        # Battery Notifications
      #blueman          # Bluetooth
      #light            # Display Brightness
      #libreoffice      # Office Tools
      #simple-scan      # Scanning
      #
      #obs-studio       # Recording/Live Streaming
      thunderbird       # email client
      spotify
      obsidian        # Text Editor
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

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      #name = "Dracula";
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      #package = pkgs.dracula-theme;
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
      #name = "JetBrains Mono Medium";
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
