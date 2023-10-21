{ config, lib, pkgs, ... }:

let
  themes = pkgs.callPackage ./sddm-themes/sugar-dark.nix {};
in {
  environment.systemPackages = with pkgs; [
    themes.sddm-sugar-dark

    # Dependencies of sugar dark theme
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtsvg
  ];

  services = {
    xserver = {
      displayManager.sddm = {
        enable = true;
        theme = "sugar-dark";
      };
    };
  };
}
