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
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      history.size = 100000;

      oh-my-zsh = {                               # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
      };

      initExtra = ''
        function loc {
          nix-locate --top-level -w /bin/$1
        }
        function exa-nixpkgs-derivation {
          nix run nixpkgs#eza -- --tree $(nix build nixpkgs#$1 --print-out-paths --out-link /tmp/$1)
        }

        # source /etc/set-environment
      '';
    };
  };
}
