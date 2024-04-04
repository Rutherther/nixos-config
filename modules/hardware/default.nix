#
#  Hardware
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./hardware
#           └─ default.nix *
#               └─ ...
#
{
  imports = [
    ./bluetooth.nix
  ];
}
