{ config, lib, pkgs, nixpkgs, ... }:

let
  pythonEnvPackages = ppkgs: [
    ppkgs.qtile-extras
    ppkgs.xlib
    ppkgs.screeninfo
    ppkgs.pyudev
    ppkgs.pydbus
  ];
in {
  environment.systemPackages = with pkgs; [
    xkblayout-state
  ];

  services = {
    xserver = {
      enable = true;
      windowManager.qtile = {
        enable = true;

        package = pkgs.qtile-unwrapped.overridePythonAttrs(oldAttrs: {
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ pythonEnvPackages pkgs.python3Packages;
        });

        extraPackages = pythonEnvPackages;
      };
    };
  };
}
