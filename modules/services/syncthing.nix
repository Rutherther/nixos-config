{ config, lib, pkgs, user, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };

  services.syncthing = {
    enable = true;
    user = "${user}";
    configDir = "/home/${user}/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      "phone" = { id = inputs.semi-secrets.syncthing.devices.phone; };
    };
    folders = {
      "University" = {
        path = "/home/${user}/Documents/uni";
        devices = [ "phone" ];
      };
      "Notes" = {
        path = "/home/${user}/Documents/notes/obsidian/Notes";
        devices = [ "phone" ];
      };
      "Camera" = {
        path = "/home/${user}/Documents/camera";
        devices = [ "phone" ];
      };
      "study" = {
        path = "/home/${user}/Documents/study";
        devices = [ "phone" ];
      };
    };
    extraOptions.options = {
      natenabled = false;
      relaysEnabled = false;
      globalAnnounceEnabled = false;
      localAnnounceEnabled = true;
      #alwaysLocalNets = true;
    };
  };
}
