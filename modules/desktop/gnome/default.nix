#
# Gnome configuration
#

{ pkgs, ... }:

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
      (gnomeExtensions.disable-workspace-switch-animation-for-gnome-40.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "tmke8";
          repo = "gnome-shell-extension-instant-workspace-switcher";
          rev = "patch-1";
          hash = "sha256-Ual7kAOeGPe3DF5XHf5eziscYeMLUnDktEGU41Yl4E4=";
        } + "/instantworkspaceswitcher@amalantony.net";
      })
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
