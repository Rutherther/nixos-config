#
#  Apps
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./programs
#           └─ default.nix *
#               └─ ...
#

{
  imports = [
    ./alacritty.nix
    ./iamb.nix
    ./rofi.nix
    ./clipmenu.nix
    ./firefox.nix
    ./email.nix
  ];
}
