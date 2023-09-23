{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      qtile
      python310Packages.qtile-extras
    ];
  };

  services = {
    xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
