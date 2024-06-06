{ config, lib, ... }:

{
  options.usersList = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config = {
    usersList = [ "root" "nixos" "ruther" ];

    users.users = lib.mkMerge [
      (lib.genAttrs config.usersList (name: {
        extraGroups = [ "input" ];
      }))
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
