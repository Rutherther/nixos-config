{ config, lib, pkgs, nixpkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xkblayout-state
  ];

  services = {
    xserver = {
      enable = true;
      windowManager.qtile = {
        enable = true;
        extraPackages = ppkgs: [
          ppkgs.qtile-extras
          ppkgs.xlib
          ppkgs.screeninfo
        ];
      };
    };
  };
}
