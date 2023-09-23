{ config, lib, pkgs, location, ... }:

{
  xdg.configFile."qtile/config.py".source = ./config/config.py;
  xdg.configFile."qtile/bluetooth.py".source = ./config/bluetooth.py;
  xdg.configFile."qtile/mpris2widget.py".source = ./config/mpris2widget.py;
  xdg.configFile."qtile/tasklist.py".source = ./config/tasklist.py;

  xdg.configFile."qtile/nixenvironment.py".text = ''
from string import Template
import os

setupLocationRef = Template("${location}")
configLocationRef = Template("${location}/modules/desktop/qtile/config")

setupLocation = setupLocationRef.substitute(os.environ)
configLocation = configLocationRef.substitute(os.environ)
  '';
}
