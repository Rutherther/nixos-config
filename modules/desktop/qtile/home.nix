{ config, lib, pkgs, ... }:

{
  xdg.configFile."qtile".source = ./qtile;
}
