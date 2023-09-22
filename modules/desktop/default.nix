{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      layout = "us,cz";                              # Keyboard layout & €-sign
      xkbVariant = ",qwerty";
      xkbOptions = "eurosign:e";
      libinput.enable = true;
      modules = [ pkgs.xf86_input_wacom ];        # Both needed for wacom tablet usage
      wacom.enable = true;
    };
  };
}
