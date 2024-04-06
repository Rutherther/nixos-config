{ lib, config, pkgs, ... }:

{
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

    home.packages = [
      pkgs.ksnip
    ];

    xdg.configFile."qtile/config.py".source = ./config/config.py;
    xdg.configFile."qtile/utils.py".source = ./config/utils.py;
    xdg.configFile."qtile/functions.py".source = ./config/functions.py;
    xdg.configFile."qtile/bars.py".source = ./config/bars.py;
    xdg.configFile."qtile/screens.py".source = ./config/screens.py;
    xdg.configFile."qtile/styling.py".source = ./config/styling.py;

    xdg.configFile."qtile/tasklist.py".source = ./config/tasklist.py;
    xdg.configFile."qtile/xmonadcustom.py".source = ./config/xmonadcustom.py;
    xdg.configFile."qtile/sequence-detector.config.json".source = ./config/sequence-detector.config.json;

    xdg.configFile."qtile/nixenvironment.py".text = ''
      from string import Template
      import os

      setupLocationRef = Template("${config.nixos-config.location}")
      configLocationRef = Template("${config.nixos-config.location}/modules/desktop/qtile/config")

      setupLocation = setupLocationRef.substitute(os.environ)
      configLocation = configLocationRef.substitute(os.environ)

      sequenceDetectorExec = "sequence_detector -c /home/${config.nixos-config.defaultUser}/.config/qtile/sequence-detector.config.json "
    '';
  };
}
