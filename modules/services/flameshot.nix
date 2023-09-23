#
# Screenshots
#

{ config, lib, pkgs, user, ... }:

{
  services = {                                    # sxhkd shortcut = Printscreen button (Print)
    flameshot = {
      enable = true;
      settings = {
        General = {                               # Settings
          savePath = "/home/${user}/screens";
          saveAsFileExtension = ".png";
          uiColor = "#2d0096";
          showHelp = "false";
          disabledTrayIcon = "true";              # Hide from systray
        };
      };
    };
  };
}
