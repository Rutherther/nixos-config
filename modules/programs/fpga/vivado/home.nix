{ config, lib, pkgs, vivadoPath, stable, ... }:

let
  vivadoPkg = pkgs.callPackage ./vivado-pkg.nix { inherit vivadoPath stable; };
  fhsPkg = pkgs.callPackage ./fhs.nix { inherit vivadoPath stable; };
in {
  home.packages = [
    fhsPkg
  ];
}
