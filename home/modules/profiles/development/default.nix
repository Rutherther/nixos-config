{ config, lib, ... }:

{
  options = {
    profiles.development = {
      enable = lib.mkEnableOption "Enable development profile (emacs, nvim)";
    };
  };

  imports = [
    ./emacs
    ./nvim.nix
  ];

  config = lib.mkIf config.profiles.development.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      git = {
        enable = true;
        includes = [{
          contents = {
            user = {
              email = "rutherther@proton.me";
              name = "Rutherther";
            };
            init = {
              defaultBranch = "main";
            };
          };
        }];
      };
    };
  };
}
