#
# Gnome configuration
#

{ config, lib, pkgs, ... }:

let
  paperwm = pkgs.stdenv.mkDerivation (finalAttrs: rec {
    pname = "gnome-shell-extension-paperwm";
    version = "44.15.1";

    src = pkgs.fetchFromGitHub {
      owner = "paperwm";
      repo = "PaperWM";
      rev = "v${version}";
      hash = "sha256-89tW/3TLx7gvjnQfpfH8fkaxx7duYXRiCi5bkBRm9UU=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/gnome-shell/extensions/paperwm@paperwm.github.com"
      cp -r . "$out/share/gnome-shell/extensions/paperwm@paperwm.github.com"

      runHook postInstall
    '';

    passthru.extensionUuid = "paperwm@paperwm.github.com";
  });
in {
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    kdeconnect = {                                # For GSConnect
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  services = {
    xserver.desktopManager.gnome.enable = true;
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  environment = {
    systemPackages = with pkgs; [                 # Packages installed
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      gnomeExtensions.fullscreen-avoider
      gnomeExtensions.vitals
      gnomeExtensions.openweather
      gnomeExtensions.clipboard-history
      gnomeExtensions.forge
      gnomeExtensions.switcher
      (gnomeExtensions.disable-workspace-switch-animation-for-gnome-40.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "tmke8";
          repo = "gnome-shell-extension-instant-workspace-switcher";
          rev = "patch-1";
          hash = "sha256-Ual7kAOeGPe3DF5XHf5eziscYeMLUnDktEGU41Yl4E4=";
        } + "/instantworkspaceswitcher@amalantony.net";
      })

      # paperwm
    ];
    gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      pkgs.gedit
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-contacts
      gnome-initial-setup
    ]);
  };
}
