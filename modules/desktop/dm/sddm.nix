{ config, lib, pkgs, ... }:

let
  themes = pkgs.callPackage ./sddm-themes/sugar-dark.nix {};
in {
  environment.systemPackages = [
    themes.sddm-sugar-dark
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
