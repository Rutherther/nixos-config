{ config, lib, pkgs, vivadoPath, ... }:

let
  vivadoPkg = pkgs.callPackage ./vivado-pkg.nix {  };
in {
  services.udev.packages = [
    vivadoPkg
  ];
}
