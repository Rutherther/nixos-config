{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "us,cz";                              # Keyboard layout & €-sign
        variant = ",qwerty";
        options = "grp:alt_shift_toggle, ctrl:nocaps";
      };
      libinput.enable = true;
      modules = [ pkgs.xf86_input_wacom ];        # Both needed for wacom tablet usage
      wacom.enable = true;
    };
  };
}
