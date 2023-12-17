{ inputs, system, config, lib, pkgs, vivadoPath, ... }:

{
  services.udev.packages = [
    inputs.nix-fpga-tools.packages.x86_64-linux.ise-udev-rules
    inputs.nix-fpga-tools.packages.x86_64-linux.vivado-udev-rules
  ];
}
