#
# Shell
#

{ pkgs, ... }:

{
  programs = {
    starship = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      history.size = 100000;

      oh-my-zsh = {                               # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
      };
    };
  };
}
