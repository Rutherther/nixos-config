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
  laptop-iapetus = lib.nixosSystem {                                # Laptop profile
    # Ideapad S540
    specialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ./laptop-iapetus
      ./configuration.nix
    ];
  };

  laptop-phobos = lib.nixosSystem {                                # Laptop profile
    # Thinkpad T14s
    specialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
      ./laptop-phobos
      ./configuration.nix
    ];
  };

  desktop-clotho = lib.nixosSystem {                               # Desktop profile
    specialArgs = {
      inherit inputs;
    };
    modules = [
      ./desktop-clotho
      ./configuration.nix
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    specialArgs = {
      inherit inputs;
    };
    modules = [
      ./vm
      ./configuration.nix
    ];
  };
}
