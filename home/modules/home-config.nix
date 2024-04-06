{ config, pkgs, lib, ... }:

{
  options = {
    home-config = {
      defaultTerminal = lib.mkPackageOption pkgs "kitty" {};
      defaultTerminalExe = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
      };

      defaultFont = lib.mkOption {
        type = lib.types.str;
        default = "FiraCode Nerd Font Mono";
      };

      startup = {
        apps = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = ''
            Which apps to start when entering GUI
          '';
        };
      };
    };
  };

  config = {
    home-config.defaultTerminalExe = (lib.getExe config.home-config.defaultTerminal);
  };
}
