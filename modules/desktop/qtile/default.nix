{ config, lib, pkgs, nixpkgs, ... }:

{
  imports = [(import ./python-overlay.nix)];

  environment.systemPackages = with pkgs; [
    playerctl
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
