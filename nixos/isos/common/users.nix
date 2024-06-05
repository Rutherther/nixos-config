{ lib, ... }:

{
  options.usersList = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config = {
    usersList = [ "root" "nixos" "ruther" ];
    # usersList = lib.attrNames config.users.users? infrec?

    users.users = lib.mkMerge [
      {
        ruther = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          initialHashedPassword = "";
        };
      }
    ];
  };
}
