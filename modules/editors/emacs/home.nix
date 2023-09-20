#
# Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# This is an ideal way to install on a vanilla NixOS installion.
# You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ ./doom-emacs
#                   └─ ./alt
#                       └─ native.nix *
#


{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
    sha256 = "1sczbw6q80l5qasbkp0lnsw8zsh79xg2prhnpv8qxn4zih72kx73";
  }) {
    doomPrivateDir = ./doom.d;  # Directory containing your config.el init.el
                                # and packages.el files
  };
in {
  home.packages = [ doom-emacs ];
  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';

  programs.emacs.package = doom-emacs;

  environment.systemPackages = with pkgs; [
    ripgrep
    coreutils
    fd
    git
  ];
}
