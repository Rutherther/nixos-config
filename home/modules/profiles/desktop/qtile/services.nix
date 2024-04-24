{ inputs, config, lib, pkgs, ... }:

let
  mpris-ctl = inputs.self.packages.${pkgs.system}.mpris-ctl;
  sequence-detector = inputs.self.packages.${pkgs.system}.sequence-detector;
in {
  config = lib.mkIf config.profiles.desktop.qtile.enable {

    home.packages = lib.mkMerge [
      (lib.mkIf config.services.dunst.enable [ pkgs.libnotify ])
      [
        mpris-ctl
        sequence-detector
      ]
    ];

    services = {                            # Applets
      network-manager-applet.enable = true; # Network
      autorandr.enable = true;

      dunst = {
        enable = true;
        iconTheme = {                                       # Icons
          name = "Papirus Dark";
          package = pkgs.papirus-icon-theme;
          size = "16x16";
        };
        settings = with config.themes.default; {               # Settings
          global = {
            monitor = 0;
            follow = "keyboard";
            # geometry [{width}x{height}][+/-{x}+/-{y}]
            # geometry = "600x50-50+65";
            width = 300;
            height = 200;
            origin = "top-right";
            offset = "50x50";
            shrink = "yes";
            transparency = 10;
            padding = 16;
            gap_size = 5;
            horizontal_padding = 16;
            frame_width = 2;
            frame_color = "#${background.active}";
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
            background = "#${background.primary}";
            foreground = "#${foreground.text}";
            timeout = 4;
          };
          urgency_normal = {
            background = "#${background.primary}";
            foreground = "#${foreground.text}";
            timeout = 4;
          };
          urgency_critical = {
            background = "#${background.primary}";
            foreground = "#${foreground.text}";
            frame_color = "#${urgent}";
            timeout = 10;
          };
        };
      };

      picom = {
        enable = false;
        package = pkgs.picom;

        backend = "glx";                              # Rendering either with glx or xrender. You'll know if you need to switch this.
        vSync = true;                                 # Should fix screen tearing

        #activeOpacity = 0.93;                         # Node transparency
        #inactiveOpacity = 0.93;
        #menuOpacity = 0.93;

        shadow = false;                               # Shadows
        shadowOpacity = 0.75;
        fade = true;                                  # Fade
        fadeDelta = 10;
        opacityRules = [                              # Opacity rules if transparency is prefered
        #  "100:name = 'Picture in picture'"
        #  "100:name = 'Picture-in-Picture'"
        #  "85:class_i ?= 'rofi'"
          # "90:class_i *= 'discord'"
          # "90:class_i *= 'telegram-desktop'"
          # "90:class_i *= 'emacs'"
          # "90:class_i *= 'Alacritty'"
        #  "100:fullscreen"
        ];                                            # Find with $ xprop | grep "WM_CLASS"

        settings = {
          daemon = true;
          use-damage = false;                         # Fixes flickering and visual bugs with borders
          resize-damage = 1;
          refresh-rate = 0;
          corner-radius = 5;                          # Corners
          round-borders = 5;

          # Extras
          detect-rounded-corners = true;              # Below should fix multiple issues
          detect-client-opacity = false;
          detect-transient = true;
          detect-client-leader = false;
          mark-wmwim-focused = true;
          mark-ovredir-focues = true;
          unredir-if-possible = true;
          glx-no-stencil = true;
          glx-no-rebind-pixmap = true;
        };                                           # Extra options for picom.conf (mostly for pijulius fork)
      };

      redshift = {
        enable = true;
        temperature.night = 3000;
        latitude = 50.2332933;
        longitude = 14.3225926;
      };

      udiskie = {                         # Udiskie wil automatically mount storage devices
        enable = true;
        automount = true;
        tray = "auto";                    # Will only show up in systray when active
      };
    };
    xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source = "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";

    systemd.user.targets.wm-services = {
      Unit = {
        Description = "A target that is enabled when starting Qtile";
        Requires = [ "graphical-session.target" ];
      };
    };

    systemd.user.services = {
      mpris-ctld = {
        Unit = {
          Description = "Daemon for mpris-ctl cli, that will keep track of last playing media";
          PartOf = [ "wm-services.target" ];
        };

        Install = {
          WantedBy = [ "wm-services.target" ];
        };

        Service = {
          ExecStart = "${mpris-ctl}/bin/mpris-ctld";
        };
      };

      network-manager-applet = lib.mkIf config.services.network-manager-applet.enable {
        Unit = {
          After = lib.mkForce [];
          PartOf = lib.mkForce [ "wm-services.target" ];
        };
        Install.WantedBy = lib.mkForce [ "wm-services.target" ];
      };

      autorandr = lib.mkIf config.services.autorandr.enable {
        Unit.PartOf = lib.mkForce [ "wm-services.target" ];
        Install.WantedBy = lib.mkForce [ "wm-services.target" ];
      };

      dunst = lib.mkIf config.services.dunst.enable {
        Unit = {
          PartOf = lib.mkForce [ "wm-services.target" ];
          After = lib.mkForce [];
        };
        Service = {
          # Remove reference to BusName so dunst is not started under Gnome!
          Type = lib.mkForce "simple";
          BusName = lib.mkForce "empty.dbus.name.placeholder";
        };
        Install = {
          WantedBy = lib.mkForce [ "wm-services.target" ];
        };
      };

      flameshot = lib.mkIf config.services.flameshot.enable {
        Unit = {
          PartOf = lib.mkForce [ "wm-services.target" ];
        };
        Install = {
          WantedBy = lib.mkForce [ "wm-services.target" ];
        };
      };

      picom = lib.mkIf config.services.picom.enable {
        Unit = {
          PartOf = lib.mkForce [ "wm-services.target" ];
        };
        Install = {
          WantedBy = lib.mkForce [ "wm-services.target" ];
        };
      };

      redshift = lib.mkIf config.services.redshift.enable {
        Unit = {
          PartOf = lib.mkForce [ "wm-services.target" ];
        };
        Install = {
          WantedBy = lib.mkForce [ "wm-services.target" ];
        };
      };
    };
  };
}
