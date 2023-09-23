#
# Screenshots
#

{ config, lib, pkgs, user, ... }:

let
  screensDir = "/home/${user}/screens";
in {
  services = {                                    # sxhkd shortcut = Printscreen button (Print)
    flameshot = {
      enable = true;
      settings = {
        General = {                               # Settings
          savePath = screensDir;
          saveAsFileExtension = ".png";
          uiColor = "#2d0096";
          showHelp = "false";
          disabledTrayIcon = "true";              # Hide from systray
        };
      };
    };
  };

  home.activation = {
    ensureScreensDirCreated = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${screensDir}
    '';
  };
}
