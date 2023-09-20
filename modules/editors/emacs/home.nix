#
# Personal Emacs config. Can be set up with vanilla nixos or with home-manager (see comments at bottom)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix *
#


{ config, user, unstable, pkgs, doom-emacs, location, ... }:

let
  emacs-with-packages = ((pkgs.emacsPackagesFor pkgs.emacs29).emacsWithPackages (epkgs: [
      epkgs.vterm
      epkgs.sqlite
      epkgs.treesit-grammars.with-all-grammars
    ]));
in {
  services.emacs = {
    enable = true;
    package = emacs-with-packages;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = emacs-with-packages;
  };
}
