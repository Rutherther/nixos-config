#
# System notifications
#

{ config, lib, pkgs, ... }:

let
  colors = import ../themes/colors.nix;                 # Import colors theme
in
{
  home.packages = lib.mkIf config.services.dunst.enable [ pkgs.libnotify ];                   # Dependency

  # Remove dunst dbus Notification link so it's not started under Gnome!
  xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".enable = false;

  systemd.user.services.dunst = lib.mkIf config.services.dunst.enable {
    Unit = {
      PartOf = lib.mkForce [ "qtile-services.target" ];
      After = lib.mkForce [];
    };
    Service = {
      # Remove reference to BusName so dunst is not started under Gnome!
      Type = lib.mkForce "simple";
      BusName = lib.mkForce "empty.dbus.name.placeholder";
    };
    Install = {
      WantedBy = lib.mkForce [ "qtile-services.target" ];
    };
  };

  services.dunst = {
    enable = true;
    iconTheme = {                                       # Icons
      name = "Papirus Dark";
      package = pkgs.papirus-icon-theme;
      size = "16x16";
    };
    settings = with colors.scheme.doom; {               # Settings
      global = {
        monitor = 2;
        # geometry [{width}x{height}][+/-{x}+/-{y}]
        # geometry = "600x50-50+65";
        width = 300;
        height = 200;
        origin = "top-right";
        offset = "50x50";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 3;
        frame_color = "#${bg}";
        separator_color = "frame";
        font = "FiraCode Nerd Font 10";
        line_height = 4;
        idle_threshold = 120;
        markup = "full";
        format = ''<b>%s</b>\n%b'';
        alignment = "left";
        vertical_alignment = "center";
        icon_position = "left";
        word_wrap = "yes";
        ignore_newline = "no";
        show_indicators = "yes";
        sort = true;
        stack_duplicates = true;
        # startup_notification = false;
        hide_duplicate_count = true;
      };
      urgency_low = {                                   # Colors
        background = "#${bg}";
        foreground = "#${text}";
        timeout = 4;
      };
      urgency_normal = {
        background = "#${bg}";
        foreground = "#${text}";
        timeout = 4;
      };
      urgency_critical = {
        background = "#${bg}";
        foreground = "#${text}";
        frame_color = "#${red}";
        timeout = 10;
      };
    };
  };
  xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source = "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";
}
