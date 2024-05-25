{ config, lib, pkgs, ... }:

let
  pythonEnvPackages = ppkgs: [
    ppkgs.qtile-extras
    ppkgs.xlib
    ppkgs.screeninfo
    ppkgs.pyudev
    ppkgs.pydbus
  ];
  finalPackage = pkgs.qtile-unwrapped.overridePythonAttrs(oldAttrs: {
    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ pythonEnvPackages pkgs.python3Packages;
    passthru.providedSessions = [ "qtile" "qtile-wayland" ];
    postInstall = (oldAttrs.postInstall or "") + ''
      mkdir -p $out/share/xsessions $out/share/wayland-sessions
      cp resources/qtile-wayland.desktop $out/share/wayland-sessions
      cp resources/qtile.desktop $out/share/xsessions
    '';
  });
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

      package = finalPackage;

      extraPackages = pythonEnvPackages;
    };

    # xdg.portal.wlr.enable = true;
    # xdg.portal.config.qtile.default = lib.mkDefault [ "wlr" "gtk" ];

    services.displayManager.sessionPackages = [ finalPackage ];

    services.xserver.windowManager.session = [{
      name = "qtile-wayland";
      start = ''
        ${finalPackage}/bin/qtile start -b wayland &
        waitPID=$!
      '';
    }];
  };
}
