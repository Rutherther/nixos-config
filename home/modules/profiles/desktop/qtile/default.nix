{ lib, inputs, config, pkgs, ... }:

let
  configFormat = pkgs.formats.json {};
  configJson = configFormat.generate "qtile-config.json" {
    theme = config.themes.default;
    scripts = {
      brightness = ./config/brightness.sh;
      notifications = {
        clear_popups = "${inputs.self}/scripts/notifications/clear-popups.sh";
        pause = "${inputs.self}/scripts/notifications/pause.sh";
        unpause = "${inputs.self}/scripts/notifications/unpause.sh";
        show_center = "${inputs.self}/scripts/notifications/show-center.sh";
      };
    };
    wallpaper = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/c68a508b95baa0fcd99117f2da2a0f66eb208bbf/wallpapers/nix-wallpaper-nineish-dark-gray.png";
      hash = "sha256-nhIUtCy/Hb8UbuxXeL3l3FMausjQrnjTVi1B3GkL9B8=";
    };
    defaults = {
      terminal = config.home-config.defaultTerminal.meta.mainProgram;
    };
    programs = {
      sequence_detector = "${lib.getExe inputs.self.packages.${pkgs.system}.sequence-detector} -c ${./config/sequence-detector.config.json}";
    };
    startup = {
      apps = config.home-config.startup.apps;
      hooks = [
        "systemctl start --user xorg-wm-services.target"
      ];
    };
  };
in {
  imports = [
    ./launcher.nix
    ./services.nix
    ./autorandr.nix
  ];

  options = {
    profiles.desktop.qtile = {
      enable = lib.mkEnableOption "qtile";
    };
  };

  config = lib.mkIf config.profiles.desktop.qtile.enable {
    profiles.desktop.enable = true;

    home.packages = [
      pkgs.ksnip
    ];

    home.file.".sessions/start-qtile".source = pkgs.writeShellApplication {
      name = "start-qtile";
      runtimeInputs = [
        pkgs.xorg.xinit
      ];
      text = ''
        startx ${pkgs.writeShellScript "qtile-internal" ''
          autorandr -c
          qtile start -b x11
          systemctl stop --user graphical-session.target
        ''}
      '';
    } + "/bin/start-qtile";

    # xdg.configFile."qtile/config.py".text = ''
    #   import sys
    #   sys.path.insert(0, "${./config}")
    #   import config
    # '';

    xdg.configFile."qtile/nixenvironment.py".text = ''
      import json

      class obj(object):
          def __init__(self, dict_):
              self.__dict__.update(dict_)

      with open('${configJson}', 'r') as f:
        nixConfig = json.load(f, object_hook = obj)
      print('Loaded nix config')
    '';

    xdg.configFile."qtile/config.py".source = ./config/config.py;
    xdg.configFile."qtile/utils.py".source = ./config/utils.py;
    xdg.configFile."qtile/functions.py".source = ./config/functions.py;
    xdg.configFile."qtile/bars.py".source = ./config/bars.py;
    xdg.configFile."qtile/screens.py".source = ./config/screens.py;

    xdg.configFile."qtile/tasklist.py".source = ./config/tasklist.py;
    xdg.configFile."qtile/xmonadcustom.py".source = ./config/xmonadcustom.py;
  };
}
