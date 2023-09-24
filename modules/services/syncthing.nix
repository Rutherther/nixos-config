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
      "nixos-desktop" = { id = inputs.semi-secrets.syncthing.devices.desktop; };
    };
    folders = {
      "uni" = {
        path = "/home/${user}/doc/uni";
        devices = [ "phone" "nixos-desktop" ];
      };
      "notes" = {
        path = "/home/${user}/doc/notes/obsidian/Notes";
        devices = [ "phone" "nixos-desktop" ];
      };
      "camera" = {
        path = "/home/${user}/doc/camera";
        devices = [ "phone" "nixos-desktop" ];
      };
      "study" = {
        path = "/home/${user}/doc/study";
        devices = [ "phone" "nixos-desktop" ];
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
