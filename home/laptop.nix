{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.nixos-config.isLaptop {
    home.packages = [
      pkgs.acpi
    ];

    services.cbatticon = {
      enable = true;
      criticalLevelPercent = 10;
      lowLevelPercent = 20;
    };

    # TODO put to qtile under if isLaptop
    systemd.user.services.cbatticon = lib.mkIf config.services.cbatticon.enable {
      Unit = {
        After = lib.mkForce [];
        PartOf = lib.mkForce [ "wm-services.target" ];
      };
      Install.WantedBy = lib.mkForce [ "wm-services.target" ];
    };
  };
}
