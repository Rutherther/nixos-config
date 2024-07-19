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


{ config, lib, inputs, pkgs, ... }:

let
  vterm = pkgs.emacsPackages.vterm;
  emacsVtermPath = "${vterm}/share/emacs/site-lisp/elpa/${vterm.pname}-${vterm.version}";
in {
  config = lib.mkIf config.profiles.development.enable {
    services.emacs = {
      enable = true;
      client = {
        enable = true;
      };
      startWithUserSession = "graphical";
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: [
        epkgs.vterm
        epkgs.sqlite
        (epkgs.treesit-grammars.with-grammars (p: [
          inputs.self.packages.${pkgs.system}.tree-sitter-vhdl
        ] ++ (builtins.attrValues p)))
        epkgs.pdf-tools
      ];
    };

    programs.zsh.initExtra = ''
      # Emacs
      if [[ "$INSIDE_EMACS" = 'vterm' ]] \
          && [[ -n ${emacsVtermPath} ]] \
          && [[ -f ${emacsVtermPath}/etc/emacs-vterm-zsh.sh ]]; then
        source ${emacsVtermPath}/etc/emacs-vterm-zsh.sh

        find_file() {
            vterm_cmd find-file "$(realpath "''${@:-.}")"
        }

        say() {
            vterm_cmd message "%s" "$*"
        }

        open_file_below() {
            vterm_cmd find-file-below "$(realpath "''${@:-.}")"
        }

        vterm_set_directory() {
            vterm_cmd update-pwd "$PWD/"
        }

        autoload -U add-zsh-hook
        add-zsh-hook -Uz chpwd (){ vterm_set_directory }
      fi
    '';

    home.packages = with pkgs; [
      emacs-all-the-icons-fonts
      #binutils # for native comp

      ## My emacs dependencies
      gnutls
      fd
      ripgrep
      ripgrep-all

      delta

      ## Optional dependencies
      fd
      imagemagick
      #zstd
    ];
  };
}
