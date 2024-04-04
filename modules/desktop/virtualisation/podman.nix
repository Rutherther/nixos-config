#
# Docker
#

{ config, pkgs, user, ... }:

{
  users.groups.podman.members = [ "root" config.nixos-config.defaultUser ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
