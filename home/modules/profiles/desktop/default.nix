{ config, lib, ... }:

{
  imports = [
    ./qtile
    ./gnome.nix
  ];

  options = {
    profiles.desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };

  config = lib.mkIf config.profiles.desktop.enable {
    # TODO?
  };
}
