#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./work OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix
#

{ lib, inputs, ...}:

{
  # laptop-iapetus = lib.nixosSystem {                                # Laptop profile
  #   # Ideapad S540
  #   specialArgs = {
  #     inherit inputs;
  #   };
  #   modules = [
  #     inputs.nixos-hardware.nixosModules.common-cpu-intel
  #     inputs.nixos-hardware.nixosModules.common-gpu-intel
  #     inputs.nixos-hardware.nixosModules.common-pc-laptop
  #     inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  #     inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  #     ./hosts/laptop-iapetus
  #     ./hosts/configuration.nix
  #   ];
  # };

  laptop-phobos = lib.nixosSystem {                                # Laptop profile
    # Thinkpad T14s
    specialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
      ./hosts/laptop-phobos
      ./hosts/configuration.nix
    ];
  };

  # desktop-clotho = lib.nixosSystem {                               # Desktop profile
  #   specialArgs = {
  #     inherit inputs;
  #   };
  #   modules = [
  #     ./hosts/desktop-clotho
  #     ./hosts/configuration.nix
  #   ];
  # };

  # vm = lib.nixosSystem {                                    # VM profile
  #   specialArgs = {
  #     inherit inputs;
  #   };
  #   modules = [
  #     ./hosts/vm
  #     ./hosts/configuration.nix
  #   ];
  # };
}
