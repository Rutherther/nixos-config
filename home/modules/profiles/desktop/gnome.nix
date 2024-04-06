{ config, lib, ... }:

{
  options = {
    profiles.desktop.gnome = {
      enable = lib.mkEnableOption "gnome";
    };
  };

  config = lib.mkIf config.profiles.desktop.gnome.enable {

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
          "switcher@landau.fi"
          "fullscreen-avoider@noobsai.github.com"
          "instantworkspaceswitcher@amalantony.net"
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

      # "org/gnome/shell/keybindings" = builtins.listToAttrs (builtins.map (i: { name = "switch-to-application-${i}"; value = ["@as []"]; }) (builtins.genList (y: y + 1) 9));
      "org/gnome/shell/keybindings" = builtins.listToAttrs (builtins.map (i: { name = "switch-to-application-${builtins.toString i}"; value = ["@as []"]; }) (builtins.genList (y: y + 1) 9));
      "org/gnome/desktop/wm/keybindings" =
        builtins.listToAttrs (builtins.map (i: { name = "switch-to-workspace-${builtins.toString i}"; value = ["<Super>${builtins.toString i}"]; }) (builtins.genList (y: y + 1) 9)) //
        builtins.listToAttrs (builtins.map (i: { name = "move-to-workspace-${builtins.toString i}"; value = ["<Shift><Super>${builtins.toString i}"]; }) (builtins.genList (y: y + 1) 9)) //
        {
        move-to-workspace-left = ["<Super><Shift>a"];
        move-to-workspace-right = ["<Super><Shift>d"];

        close = ["<Super>w" "<Alt>F4"];
        toggle-fullscreen = ["<Super>f"];

        panel-run-dialog = ["@as []"];
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

      "org/gnome/shell/extensions/switcher" = {
        show-switcher = ["<Super>semicolon"];
      };
    };
  };
}
