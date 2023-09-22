{ config, lib, pkgs, ... }:

{
  services = {
    xserver.displayManager.gdm.enable = true;
  };
}
