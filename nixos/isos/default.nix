{ lib, inputs }:

let
  depsInjectModule = {
    options.deps-inject.inputs = lib.mkOption { type = with lib.types; attrsOf unspecified; };
    config.deps-inject.inputs = inputs;
  };
  systemModule = system: {
    nixpkgs.hostPlatform = system;
  };

  isos = {
    gnome-install-iso = system: lib.nixosSystem {
      modules = [
        ./gnome-installation.nix
        depsInjectModule
        (systemModule system)
      ];
    };

    # dwl-install-iso = system: lib.nixosSystem {
    #   modules = [
    #     ./dwl-installation.nix
    #     depsInjectModule
    #     (systemModule system)
    #   ];
    # };
  };
  systems = [ "x86_64-linux" "aarch64-linux" ];
in lib.genAttrs systems (system:
  lib.mapAttrs
    (name: iso: ((iso system).config.system.build.isoImage))
    isos
)
