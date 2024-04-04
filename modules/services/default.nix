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
    ./syncthing.nix
    ./wireguard.nix
    ./ssh.nix
  ];
}
