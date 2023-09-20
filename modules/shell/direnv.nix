#
# Direnv
#
# create a shell.nix
# create a .envrc and add use nix shell.nix
# direnv allow
# add direnv package to emacs
# add 'eval "$(direnv hook zsh)"' to .zshrc (and same for bash)
#

{ config, lib, pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
