{ config, lib, pkgs, nixpkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xkblayout-state
  ];

  nixpkgs.overlays = [
    (final: super: {
      pythonPackagesOverlays = (super.pythonPackagesOverlays or []) ++ [
        (_: pprev: {
          qtile-extras = pprev.qtile-extras.overridePythonAttrs(_: {
            doCheck = false;
          });
        })
      ];

      python3 = let self = super.python3.override {
        inherit self;
        packageOverrides = super.lib.composeManyExtensions final.pythonPackagesOverlays;
      }; in self;
      python3Packages = final.python3.pkgs;
    })
  ];

  services = {
    xserver = {
      enable = true;
      windowManager.qtile = {
        enable = true;
        extraPackages = ppkgs: [
          ppkgs.qtile-extras
        ];
      };
    };
  };
}
