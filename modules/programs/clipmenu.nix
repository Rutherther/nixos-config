{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    dmenu
    clipmenu
  ];

  services.clipmenu.enable = true;
}
