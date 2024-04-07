{ lib, config, ... }:

{
  options.nixos-config = {
    defaultUser = lib.mkOption {
        type = lib.types.str;
        default = "ruther";
    };

    location = lib.mkOption  {
      type = lib.types.str;
      default = "${config.home-manager.users.${config.nixos-config.defaultUser}.home.homeDirectory}/.setup";
      defaultText = "$HOME/.setup";
    };

    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    useBluetooth = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
}
