#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
  colors = import ../themes/colors.nix;

  themes-collection = pkgs.fetchFromGitHub {
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "f87e08300cb1c984994efcaf7d8ae26f705226fd";
    hash = "sha256-A6zIAQvjfe/XB5GZefs4TWgD+eGICQP2Abz/sQynJPo=";
  };
in
{
  home = {
    packages = with pkgs; [
      rofi-power-menu
    ];
  };

  xdg.dataFile."rofi/themes/launchpad.rasi".source = "${themes-collection}/themes/launchpad.rasi";
  xdg.dataFile."rofi/themes/spotlight.rasi".source = "${themes-collection}/themes/spotlight-dark.rasi";

  programs = {
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";           # Alacritty is default terminal emulator
      location = "center";
      font = "FiraCode Nerd Font Mono 11";
      theme =  with colors.scheme.doom; {
        # Based on spotlight theme
        "*" = {
          font =  "Montserrat 12";

          bg0 = mkLiteral "#222223e6";
          bg1 = mkLiteral "#44444480";
          bg2 = mkLiteral "#51afefe6";
          fg0 = mkLiteral "#${text}";
          fg1 = mkLiteral "#d5d5d5";
          fg2 = mkLiteral "#${fg}";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = mkLiteral "0";
          padding = mkLiteral "0";
          spacing = mkLiteral "0";
        };

        "window" = {
          background-color = mkLiteral "@bg0";

          location = mkLiteral "center";
          width = mkLiteral "640";
          border-radius = mkLiteral "0";
        };

        "inputbar" =  {
          font = "Montserrat 20";
          padding = mkLiteral "12px";
          spacing = mkLiteral "12px";
          children = mkLiteral "[ icon-search, entry ]";
        };

        "icon-search" =  {
          expand = false;
          filename = "search";
          size = mkLiteral "28px";
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        "entry" = {
          font = mkLiteral "inherit";

          placeholder = "Search";
          placeholder-color = mkLiteral "@fg2";
        };

        "message" = {
          border = mkLiteral "2px 0 0";
          border-color = mkLiteral "@bg1";
          background-color = mkLiteral "@bg1";
        };

        "textbox" = {
          padding = mkLiteral "8px 24px";
        };

        "listview" = {
          lines = 10;
          columns = mkLiteral "1";

          fixed-height = false;
          border = mkLiteral "1px 0 0";
          border-color = mkLiteral "@bg1";
        };

        "element" = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "16px";
          background-color = mkLiteral "transparent";
        };

        "element normal active" = {
          text-color = mkLiteral "@bg2";
        };

        "element selected normal, element selected active" = {
          background-color = mkLiteral "@bg2";
          text-color = mkLiteral "@fg1";
        };

        "element-icon" = {
          size = mkLiteral "1em";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };
      };
    };
  };
}
