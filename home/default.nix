{ config, inputs, pkgs, ... }:

{
  imports = [
    ./modules
    ../nixos/modules/nixos-config.nix
    ./laptop.nix
  ];

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;
  };

  home.sessionVariables = {
    NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
    TERMINAL = config.home-config.defaultTerminal.meta.mainProgram;
    EDITOR = "emacsclient -cn";
  };

  xdg = {
    userDirs = let dir = s: "${config.home.homeDirectory}/${s}"; in {
      enable = true;
      documents = dir "doc";
      download = dir "download";
      music = dir "music";
      pictures = dir "photos";
      publicShare = dir "public";
      videos = dir "videos";
    };
    mimeApps = {
      enable = true;
      defaultApplications = let
        imageViewer = "sxiv.desktop";
        videoViewer = "mpv.desktop";
        pdfViewer = "org.pwmt.zathura.desktop";
        textEditor = "emacs-client.desktop";
        webBrowser = "firefox.desktop";
        fileBrowser = "emacs-client.desktop"; # "nautilus.desktop";
      in {
        # see https://www.iana.org/assignments/media-types/media-types.xhtml

        # Pdf
        "application/pdf" = pdfViewer;

        # Image
        "image/png" = imageViewer;
        "image/jpeg" = imageViewer;
        "image/gif" = imageViewer;
        "image/tiff" = imageViewer;
        "image/webp" = imageViewer;

        # Video
        "application/mp4" = videoViewer;
        "video/mpeg" = videoViewer;
        "video/h264" = videoViewer;
        "video/h265" = videoViewer;
        "video/h266" = videoViewer;

        # Text Editor
        "application/x-shellscript" = textEditor;
        "text/plain" = textEditor;
        "text/x-python3" = textEditor;
        "text/javascript" = textEditor;
        "text/markdown" = textEditor;

        # Web Browser
        "text/html" = webBrowser;
        "x-scheme-handler/http" = webBrowser;
        "x-scheme-handler/https" = webBrowser;
        "x-scheme-handler/chrome" = webBrowser;
        "x-scheme-handler/about" = webBrowser;
        "x-scheme-handler/unknown" = webBrowser;

        # File Browser
        "x-scheme-handler/file" = fileBrowser;

        # Chat
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      };
    };
  };

  home = {
    username = config.nixos-config.defaultUser;
    homeDirectory = "/home/${config.nixos-config.defaultUser}";

    packages = with pkgs; [
      # Terminal
      gtop              # Resource Manager
      htop              # Resource Manager
      ranger            # File Manager
      cinnamon.nemo     # GUI File Manager
      tldr              # Helper
      lazygit           # Git tool

      # Video/Audio
      sxiv              # Image Viewer
      feh               # Image Viewer
      mpv               # Media Player
      pavucontrol       # Audio Control
      vlc               # Media Player

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
      alacritty
      kitty

      # Desktop
      discord           # Chat
      telegram-desktop  # Chat
      element-desktop  # Chat
      cinny-desktop     # Chat
      ffmpeg           # Video Support (dslr)

      spotify
      # obsidian        # Text Editor

      comma
      bat
      ripgrep

      pinta

      easyeffects
    ];

    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
    nix-index = {
      enableZshIntegration = false;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
  };

  services = {
    easyeffects.enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Frappe-Sapphire-Cursors";
    package = pkgs.catppuccin-cursors.frappeSapphire;
    size = 16;
  };
  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Graphite-orange-Dark";
      package = pkgs.graphite-gtk-theme.override {
        themeVariants = ["orange"];
        colorVariants = ["dark"];
      };
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";
      size = 10;
    };                                        # Cursor is declared under home.pointerCursor
  };

  systemd.user.targets.tray = {               # Tray.target can not be found when xsession is not enabled. This fixes the issue.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}