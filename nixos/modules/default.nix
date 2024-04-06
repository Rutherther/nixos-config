{ config, lib, ... }:

{
  imports = [
    ./profiles
    ./nixos-config.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf config.nixos-config.useBluetooth {
      hardware.bluetooth = {
        enable = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      };
      services.blueman.enable = true;
    })
  ];
}
