{ config, lib, pkgs, ... }:

{
  imports = [
    ./qtile.nix
    ./gnome.nix
  ];

  options = {
    profiles.desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };

  config = lib.mkIf config.profiles.desktop.enable {

    environment.systemPackages = [
      pkgs.xkblayout-state
    ];

    services = {
      libinput.enable = true;
      xserver = {
        enable = true;

        # displayManager.gdm.enable = true;

        xkb = {
          layout = "us,cz";                              # Keyboard layout & €-sign
          variant = ",qwerty";
          options = "grp:alt_shift_toggle, ctrl:nocaps";
        };
        modules = [ pkgs.xf86_input_wacom ];        # Both needed for wacom tablet usage
        wacom.enable = true;
      };
    };
  };
}
