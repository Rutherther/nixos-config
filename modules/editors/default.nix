#
#  Editors
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./home.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#

[
  ./emacs/doom-emacs
]

# Comment out emacs if you are not using native doom emacs. (import from host configuration.nix)
