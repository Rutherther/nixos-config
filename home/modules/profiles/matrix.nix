{ config, lib, pkgs, ... }:

{
  options = {
    profiles.matrix =  {
      enable = lib.mkEnableOption "Enable matrix client";
    };
  };

  config = lib.mkIf config.profiles.matrix.enable {
    home.packages = [
      pkgs.element
      pkgs.cinny
    ];

    programs.iamb = {
      enable = true;
      settings = {
        profiles = {
          "ditigal.xyz" = {
            user_id = "@ruther:ditigal.xyz";
          };
        };

        settings = {
          username_display = "displayname";
          image_preview = {};

          sort.rooms = [ "favorite" "unread" "recent" "lowpriority" "name" ];

        };

        macros = {
          normal = {
            "<C-h>" = "<C-W>v50<C-W>><C-W>l:dms<CR><C-W>h";
            "V" = "<C-w>m";
          };
        };
      };
    };

    home-config.startup.apps = [ (lib.getExe pkgs.element-desktop) ];
  };
}
