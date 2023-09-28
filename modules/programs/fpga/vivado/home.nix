{ config, lib, pkgs, vivadoPath, ... }:

let
  vivadoPkg = pkgs.callPackage ./vivado-pkg.nix { inherit vivadoPath; };
  fhsPkg = pkgs.callPackage ./fhs.nix { inherit vivadoPath; };
in {
  home.packages = [
    fhsPkg
  ];
}
