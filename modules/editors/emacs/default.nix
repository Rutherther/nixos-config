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


{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
  };
}
