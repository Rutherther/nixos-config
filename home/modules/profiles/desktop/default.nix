{ config, lib, pkgs, ... }:

{
  imports = [
    ./qtile
    ./dwl
    ./gnome.nix
  ];

  options = {
    profiles.desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };

  config = lib.mkIf config.profiles.desktop.enable {
    desktopSessions.enable = true;
  };
}
