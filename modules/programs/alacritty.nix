#
# Terminal Emulator
#
# Hardcoded as terminal for rofi and doom emacs
#

{ pkgs, lib, ... }:

{
  programs = {
    dircolors = {
      enable = true;
      settings = {
        OTHER_WRITABLE = "01;35"; # Make ntfs colors readable
      };
    };

    alacritty = {
      enable = true;
      settings = {
        font = rec {                          # Font - Laptop has size manually changed at home.nix
          normal.family = "FiraCode Nerd Font";
          bold = { style = "Bold"; };
          size = 12;
        };
        # offset = {                            # Positioning
        #   x = -1;
        #   y = 0;
        # };
      };
    };
  };
}
