{ config, lib, pkgs, nixpkgs, ... }:

{
  imports = [(import ./python-overlay.nix)];

  environment.systemPackages = with pkgs; [
    playerctl
    xkblayout-state
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
