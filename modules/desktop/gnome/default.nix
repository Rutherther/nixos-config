#
# Gnome configuration
#

{ config, lib, pkgs, ... }:

{
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

      (gnomeExtensions.paperwm.overrideAttrs (rec {
        version = "44.15.1";
        src = pkgs.fetchFromGitHub {
          owner = "paperwm";
          repo = "PaperWM";
          rev = "v${version}";
          hash = "sha256-89tW/3TLx7gvjnQfpfH8fkaxx7duYXRiCi5bkBRm9UU=";
        };
      }))
    ];
    gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
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
