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


{ lib, pkgs, config, ... }:

let
  doomRev = "5f5a163c49207a7083ab1ecc9e78d268fd6600b8";
in {
  services.emacs = {
    enable = true;
    client = {
      enable = true;
    };
    startWithUserSession = "graphical";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-gtk3;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.sqlite
      epkgs.treesit-grammars.with-all-grammars
    ];
  };

  home.activation = {
    linkDoomConfig = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [  ];
      data =
        ''
            EMACS=$HOME/.emacs.d
            if [ ! -d "$EMACS" ]; then
              ${pkgs.git}/bin/git clone https://github.com/doomemacs/doomemacs $EMACS
              (cd $EMACS && ${pkgs.git}/bin/git checkout ${doomRev})
            else
              curr_rev=$(cd $EMACS && ${lib.getExe pkgs.git} rev-parse HEAD)
              if [[ "$curr_rev" != "${doomRev}" ]]; then
                (cd $EMACS && ${lib.getExe pkgs.git} fetch --all && ${lib.getExe pkgs.git} checkout ${doomRev})
              fi
            fi
            if [ ! -d "$HOME/.doom.d" ]; then
                ln -s ${config.nixos-config.location}/modules/editors/emacs/doom.d $HOME/.doom.d
            fi
        '';
    };
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    #binutils # for native comp

    ## Doom emacs dependencies
    gnutls
    fd
    ripgrep

    delta

    ## Optional dependencies
    fd
    imagemagick
    #zstd
  ];
}
