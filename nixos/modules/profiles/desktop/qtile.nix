{ config, lib, pkgs, ... }:

let
  pythonEnvPackages = ppkgs: [
    ppkgs.qtile-extras
    ppkgs.xlib
    ppkgs.screeninfo
    ppkgs.pyudev
    ppkgs.pydbus
  ];
in {
  options = {
    profiles.desktop.qtile = {
      enable = lib.mkEnableOption "gnome";
    };
  };

  config = lib.mkIf config.profiles.desktop.qtile.enable {
    profiles.desktop.enable = lib.mkDefault true;

    services.xserver.windowManager.qtile = {
      enable = true;

      package = pkgs.qtile-unwrapped.overridePythonAttrs(oldAttrs: {
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ pythonEnvPackages pkgs.python3Packages;
      });

      extraPackages = pythonEnvPackages;
    };
  };
}
