{ lib, ... }:

{
  options.nixos-config = {
    defaultUser = lib.mkOption {
        type = lib.types.str;
        default = "ruther";
    };

    location = lib.mkOption  {
      type = lib.types.str;
      default = "$HOME/.setup";
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
