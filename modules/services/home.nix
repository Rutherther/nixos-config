#
#  Services
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#

{
  imports = [
    ./dunst.nix
    ./flameshot.nix
    ./picom.nix
    ./udiskie.nix
    ./redshift.nix
    ./mpris-ctl.nix
    ./autorandr.nix
  ];
}
