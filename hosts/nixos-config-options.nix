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
  };
}
