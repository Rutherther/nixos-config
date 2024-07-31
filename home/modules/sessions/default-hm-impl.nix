{ config, lib, ... }:

let
  cfg = config.desktopSessions;
in {
  options.desktopSessions.autoStart = {
    enableBashIntegration = lib.mkEnableOption "enable bash integration to .profile" // { default = true; };
    enableZshIntegration = lib.mkEnableOption "enable zsh integration to .zprofile" // { default = true; };
  };

  config = lib.mkIf (cfg.enable) {
    programs.zsh.profileExtra = lib.optionalString (cfg.autoStart.enable && cfg.autoStart.enableZshIntegration) cfg.autoStart.profileSelectContent;
    programs.bash.profileExtra = lib.optionalString (cfg.autoStart.enable && cfg.autoStart.enableBashIntegration) cfg.autoStart.profileSelectContent;

    home.file.".start-session".source = cfg.selectSession;
  };

}
