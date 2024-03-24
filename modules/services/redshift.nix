#
#  Screen color temperature changer
#
{ config, lib, pkgs, ...}:

{
  systemd.user.services.redshift = lib.mkIf config.services.redshift.enable {
    Unit = {
      PartOf = lib.mkForce [ "qtile-services.target" ];
    };
    Install = {
      WantedBy = lib.mkForce [ "qtile-services.target" ];
    };
  };

  services = {
    redshift = {
      enable = true;
      temperature.night = 3000;
      latitude = 50.2332933;
      longitude = 14.3225926;
    };
  };
}
