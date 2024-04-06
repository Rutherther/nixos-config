{ config, lib, ... }:

let
  user = config.nixos-config.defaultUser;
  homePath = config.home-manager.users.${user}.home.homeDirectory;
in {

  options = {
    profiles.sync = {
      enable = lib.mkEnableOption "sync";
    };
  };

  config = lib.mkIf config.profiles.sync.enable {

    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };

    services.syncthing = {
      enable = true;
      user = "${user}";
      dataDir = "${homePath}";
      configDir = "${homePath}/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {

        devices = {
          phone = { id = "SRCBWOD-UBR76WT-ZB4OLV2-34U6TRL-YLVMSGQ-I5JYZP6-VD7XR6S-5732ZAZ"; };
          desktop = { id = "BVFWKZE-DWZTSJR-OHCLGY3-X2PU7F3-XMPMGEH-QONACL5-MMRJE5O-CHRY4Q5"; };
          laptop = { id = "3AGVM6S-RFTHVHR-OGK5RHI-YDEO6GN-RU4ZH77-VLBZAC7-JVHD6S6-VISXGQT"; };
        };

        folders = {
          "uni" = {
            path = "${homePath}/doc/uni";
            devices = [ "phone" "desktop" "laptop" ];
          };
          "notes" = {
            path = "${homePath}/doc/notes/obsidian/Notes";
            devices = [ "phone" "desktop" "laptop" ];
          };
          "camera" = {
            path = "${homePath}/doc/camera";
            devices = [ "phone" "desktop" "laptop" ];
          };
          "study" = {
            path = "${homePath}/doc/study";
            devices = [ "phone" "desktop" "laptop" ];
          };
        };
        options = {
          natenabled = false;
          relaysEnabled = false;
          globalAnnounceEnabled = false;
          localAnnounceEnabled = true;
        };
      };
    };
  };
}
