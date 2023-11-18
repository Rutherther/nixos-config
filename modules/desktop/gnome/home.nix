#
# Gnome Home-Manager Configuration
#
# Dconf settings can be found by running "$ dconf watch /"
#

{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "Alacritty.desktop"
        "firefox.desktop"
        "emacs.desktop"
        "org.gnome.Nautilus.desktop"
        "discord.desktop"
        "telegram-desktop.desktop"
        "blueman-manager.desktop"
        "pavucontrol.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "paperwm@paperwm.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "clipboard-history@alexsaveau.dev"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      #gtk-theme = "Adwaita-dark";
    };
    "org/gnome/desktop/privacy" = {
      report-technical-problems = "false";
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      action-right-click-titlebar = "toggle-maximize";
      action-middle-click-titlebar = "minimize";
      resize-with-right-button = true;
      mouse-button-modifier = "<Super>";
      button-layout = ":minimize,close";
      num-workspaces = 9;
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = ["@as []"];
      switch-to-application-2 = ["@as []"];
      switch-to-application-3 = ["@as []"];
      switch-to-application-4 = ["@as []"];
      switch-to-application-5 = ["@as []"];
      switch-to-application-6 = ["@as []"];
      switch-to-application-7 = ["@as []"];
      switch-to-application-8 = ["@as []"];
      switch-to-application-9 = ["@as []"];
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      switch-to-workspace-8 = ["<Super>8"];
      switch-to-workspace-9 = ["<Super>9"];

      move-to-workspace-left = ["<Super><Shift>a"];
      move-to-workspace-right = ["<Super><Shift>d"];

      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
      move-to-workspace-7 = ["<Super><Shift>7"];
      move-to-workspace-8 = ["<Super><Shift>8"];
      move-to-workspace-9 = ["<Super><Shift>9"];

      close = ["<Super>w" "<Alt>F4"];
      toggle-fullscreen = ["<Super>f"];

      panel-run-dialog = "<Super>semicolon";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-interactive-ac-type = "nothing";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Shift><Super>Return";
      command = "alacritty";
      name = "open-terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "emacs-client";
      name = "open-emacs";
    };

    "org/gnome/shell/extensions/paperwm" = {
      restore-workspaces-only-on-primary = false;
      window-gap = 10;
      winprops = [ "{\"wm_class\":\"Spotify\",\"scratch_layer\":true}" ];
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      move-left = ["<Shift><Super>k"];
      move-right = ["<Shift><Super>j"];

      switch-previous = ["<Super>k"];
      switch-next = ["<Super>j"];

      move-monitor-left = ["<Shift><Super>a"];
      move-monitor-below = ["<Shift><Super>s"];
      move-monitor-right = ["<Shift><Super>d"];
      move-monitor-above = ["<Shift><Super>w"];

      swap-monitor-left = ["<Control><Super>a"];
      swap-monitor-below = ["<Control><Super>s"];
      swap-monitor-right = ["<Control><Super>d"];
      swap-monitor-above = ["<Control><Super>w"];

      switch-monitor-left = ["<Super>a"];
      switch-monitor-below = ["<Super>s"];
      switch-monitor-right = ["<Super>d"];
      switch-monitor-above = ["<Super>w"];

      new-window = ["<Super>n"];

      paper-toggle-fullscreen = ["<Shift><Super>f"];

      toggle-maximize-width = ["<Super>f"];

      toggle-scratch = ["<Shift><Super>g"];
      toggle-scratch-layer = ["<Super>g"];
    };
  };

  home.packages = with pkgs; [
  ];
}
