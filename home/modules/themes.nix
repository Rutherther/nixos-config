{ lib, ... }:

let
  mkColorOption = description: lib.mkOption {
    inherit description;
    type = lib.types.str;
  };
in {
  options = {
    themes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({config, ...}: {
        options = {
          foreground = {
            primary = mkColorOption "Primary color for foreground (text)";
            secondary = mkColorOption "Secondary color for foreground (text)";
            text = mkColorOption "Basic text color for stuff that's not primary, secondary etc.";

            active = mkColorOption "Color for foreground (text) when element is active";
            activeAlt = mkColorOption "Color for foreground when element is active, and `active` color is used as background instead";

            inactive = mkColorOption "Color for foreground (text) when element is inactive";
          };
          background = {
            primary = mkColorOption "Primary color for background";
            secondary = mkColorOption "Primary color for background";
            box = mkColorOption "Color for box elements";
            inactive = mkColorOption "Color for foreground (text) when element is inactive";
            active = mkColorOption "Color for background when element is active. When this is in use, use `foreground.activeAlt` for text.";
          };

          urgent = mkColorOption "Urgent windows";
        };
      }));
    };
  };

  config = {
    themes.default = {
      foreground = {
        primary = "51afef";
        secondary = "55eddc";
        activeAlt = "d5d5d5";
        text = "cccccc";
        active = "8babf0";
        inactive = "737373";
      };
      background = {
        primary = "222223";
        secondary = "444444";
        active = "8babf0";
        inactive = "555e60";
        box = "121212";
      };
      urgent = "c45500";
    };
  };
}
