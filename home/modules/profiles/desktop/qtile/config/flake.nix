{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem(system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {

      packages.python = pkgs.python310.withPackages (ps: with ps; [
        dbus-next
        qtile
        qtile-extras
      ]);
      packages.default = packages.python;

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [
          packages.default
        ];
        packages = [
          pkgs.nodePackages.pyright
        ];
      };

    });
}
