#
#  Screen color temperature changer
#
{ config, lib, pkgs, ...}:

{
  services = {
    redshift = {
      enable = true;
      temperature.night = 3000;
      latitude = 50.2332933;
      longitude = 14.3225926;
    };
  };
}
