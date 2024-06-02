{ lib, osConfig, ... }:

let
  # readEtcFile = etc-file:
  #   if etc-file.text != null then
  #     etc-file.text else
  #     (builtins.readFile etc-file.source);
  readEtcFile = etc-file: lib.mkMerge [
    (lib.mkIf (etc-file.text != null) etc-file.text)
    (lib.mkIf (etc-file.source != null) (builtins.readFile etc-file.source))
  ];
in {
  profiles.development.enable = true;
  profiles.desktop.qtile.enable = true;
  profiles.desktop.dwl.enable = true;
  profiles.matrix.enable = true;

  # Don't Starve doesn't pick up /etc/alsa/conf.d.
  # ALSA lib conf.c:4136:(config_file_load) cannot stat file/directory /etc/alsa/conf.d
  # This is a workaround that puts the stuff from /etc/alsa/conf.d into ~/.asoundrc that
  # Don't starve is able to read.
  home.file.".asoundrc".text = lib.mkMerge [
    (readEtcFile osConfig.environment.etc."alsa/conf.d/49-pipewire-modules.conf")
    (readEtcFile osConfig.environment.etc."alsa/conf.d/50-pipewire.conf")
    (readEtcFile osConfig.environment.etc."alsa/conf.d/99-pipewire-default.conf")
  ];
}
