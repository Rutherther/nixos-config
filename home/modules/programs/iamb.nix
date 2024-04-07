{ config, pkgs, lib, ... }:

let
  cfg = config.programs.iamb;
  settingsFormat = pkgs.formats.toml {};

  iambIcon = pkgs.fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "refs/tags/v0.0.9";
    hash = "sha256-UYc7iphpzqZPwhOn/ia7XvnnlIUvM7nSFBz67ZkXmNs=";
  } + "/docs/iamb.png";
in {
  options = {
    programs.iamb = {
      enable = lib.mkEnableOption "Enable iamb program";
      package = lib.mkPackageOption pkgs "iamb" { nullable = true;};

      enableDesktopIcon = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      settings = lib.mkOption {
        inherit (settingsFormat) type;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkMerge [
      [ cfg.package ]
      (lib.mkIf cfg.enableDesktopIcon [
        (pkgs.makeDesktopItem {
          name = "iamb";
          desktopName = "Iamb";
          comment = "Terminal Matrix.org client";
          exec = "kitty iamb"; # TODO: specify terminal
          icon = iambIcon;
        })
      ])
    ];

    xdg.configFile."iamb/config.toml".source =
      settingsFormat.generate "config.toml" config.programs.iamb.settings;
  };
}
