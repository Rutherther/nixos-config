#
# Screenshots
#

{ config, lib, ... }:

let
  screensDir = "${config.home.homeDirectory}/screens";
in {

  systemd.user.services.flameshot = lib.mkIf config.services.flameshot.enable {
    Unit = {
      PartOf = lib.mkForce [ "qtile-services.target" ];
    };
    Install = {
      WantedBy = lib.mkForce [ "qtile-services.target" ];
    };
  };

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
