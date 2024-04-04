{ config, pkgs, lib, ... }:

let
  cfg = config.programs.iamb;
  settingsFormat = pkgs.formats.toml {};
in {
  options = {
    programs.iamb = {
      enable = lib.mkEnableOption "Enable iamb program";
      package = lib.mkPackageOption pkgs "iamb" { nullable = true;};

      settings = lib.mkOption {
        inherit (settingsFormat) type;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    xdg.configFile."iamb/config.toml".source =
      settingsFormat.generate "config.toml" config.programs.iamb.settings;
  };
}
