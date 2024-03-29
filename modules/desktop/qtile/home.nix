{ config, lib, pkgs, user, location, ... }:

{
  systemd.user.targets.qtile-services = {
    Unit = {
      Description = "A target that is enabled when starting Qtile";
      Requires = [ "graphical-session.target" ];
    };
  };

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

    setupLocationRef = Template("${location}")
    configLocationRef = Template("${location}/modules/desktop/qtile/config")

    setupLocation = setupLocationRef.substitute(os.environ)
    configLocation = configLocationRef.substitute(os.environ)

    sequenceDetectorExec = "sequence_detector -c /home/${user}/.config/qtile/sequence-detector.config.json "
  '';
}
