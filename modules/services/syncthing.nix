{ inputs, config, lib, pkgs, user, ... }:

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
    settings = {

      devices = {
        "phone" = { id = inputs.semi-secrets.syncthing.devices.phone; };
        "desktop" = { id = inputs.semi-secrets.syncthing.devices.desktop; };
        "laptop-old" = { id = inputs.semi-secrets.syncthing.devices.laptop; };
        "laptop" = { id = inputs.semi-secrets.syncthing.devices.laptopPhobos; };
      };

      folders = {
        "uni" = {
          path = "/home/${user}/doc/uni";
          devices = [ "phone" "desktop" "laptop" "laptop-old" ];
        };
        "notes" = {
          path = "/home/${user}/doc/notes/obsidian/Notes";
          devices = [ "phone" "desktop" "laptop" "laptop-old" ];
        };
        "camera" = {
          path = "/home/${user}/doc/camera";
          devices = [ "phone" "desktop" "laptop" "laptop-old" ];
        };
        "study" = {
          path = "/home/${user}/doc/study";
          devices = [ "phone" "desktop" "laptop" "laptop-old" ];
        };
      };
      options = {
        natenabled = false;
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        #alwaysLocalNets = true;
      };
    };
  };
}
