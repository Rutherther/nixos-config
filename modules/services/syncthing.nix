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
      "uni" = {
        path = "/home/${user}/doc/uni";
        devices = [ "phone" ];
      };
      "notes" = {
        path = "/home/${user}/doc/notes/obsidian/Notes";
        devices = [ "phone" ];
      };
      "camera" = {
        path = "/home/${user}/doc/camera";
        devices = [ "phone" ];
      };
      "study" = {
        path = "/home/${user}/doc/study";
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
