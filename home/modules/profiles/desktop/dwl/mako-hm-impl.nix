{ config, lib, ... }:

let
  cfg = config.rutherther.programs.mako;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package # Adds dbus-1/services as well, to the XDG_DATA_DIRS.
    ];

    # xdg.dataFile."dbus-1/services/${builtins.baseNameOf (builtins.unsafeDiscardStringContext cfg.dbusFile)}".source = cfg.dbusFile;

    xdg.configFile."mako/config".source = cfg.configFile;
  };
}
