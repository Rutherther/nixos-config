{ config, nixpkgs, lib, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # nixpkgs.config.rocmSupport = true;

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
