{ config, pkgs, lib, ... }:

{
  imports = [
    ./users.nix
    ./ssh.nix
    ./vim.nix
    ./emacs.nix
    ./shell-apps.nix
  ];

  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  fonts.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "Ubuntu" ];
    })
    pkgs.font-awesome
    pkgs.ubuntu_font_family
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Ubuntu" ];
      sansSerif = [ "Ubuntu" ];
      monospace = [ "Ubuntu Mono" ];
    };
  };

  environment.systemPackages = [
    pkgs.foot
  ];

  environment.variables = {
    SELF = config.deps-inject.inputs.self;
  };

  nix = {
    settings = {
      flake-registry = "";
      experimental-features = [ "nix-command" "flakes" ];
    };

    registry =  lib.mkMerge [
      (lib.mapAttrs (n: input: {
        flake = input;
      }) config.deps-inject.inputs)

      {
        nixpkgs = lib.mkForce {
          flake = config.deps-inject.inputs.nixpkgs-stable;
        };
      }
    ];

    nixPath = [
      "nixpkgs=flake:nixpkgs"
    ];
  };
}
