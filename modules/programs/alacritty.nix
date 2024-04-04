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

    iamb = {
      enable = true;
      settings = {
        profiles = {
          "ditigal.xyz" = {
            user_id = "@ruther:ditigal.xyz";
          };
        };
        settings = {
          username_display = "displayname";
          image_preview = {};
        };
      };
    };

    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 12;
      };
      theme = "Chalk";
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
