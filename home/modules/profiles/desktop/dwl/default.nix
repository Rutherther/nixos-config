{ lib, inputs, config, pkgs, ... }:

let
  # TODO save only those that are on in somewhere like tmp,
  # after enable is called, wake up only these if the file exists
  wlopmScreens = operation: pkgs.writeShellApplication {
    name = "wlopm-all-screens-${operation}";
    runtimeInputs = [
      pkgs.wlopm
      pkgs.gawk
      pkgs.findutils
    ];
    text = ''
      screens=$(wlopm | awk '{print $1}')
      echo "$screens" | xargs -l wlopm --${operation}
    '';
  };

  wlopmDisableScreens = wlopmScreens "off";
  wlopmEnableScreens = wlopmScreens "on";

  dwl = inputs.self.packages.${pkgs.system}.dwl;

  emacs-anywhere = pkgs.writeShellScriptBin "emacs-anywhere" ''
    emacs --batch --script "${./emacs-anywhere.el}" | wl-copy
  '';
in {
  imports = [
    ./mako.nix
    ./mako-hm-impl.nix
  ];

  options = {
    profiles.desktop.dwl = {
      enable = lib.mkEnableOption "dwl";
    };
  };

  config = lib.mkIf config.profiles.desktop.dwl.enable {
    desktopSessions.instances.dwl = let
      dwlInternal = pkgs.writeShellScript "dwl-s" ''
        exec <&-
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
        systemctl start --user wlr-session.target
      '';
    in {
      environment = {
        XDG_CURRENT_DESKTOP = "wlroots";
        XDG_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      executable = lib.getExe dwl;
      arguments = [
        "-s"
        "${dwlInternal}"
      ];
    };

    profiles.desktop.enable = true;
    systemd.user.targets.wlr-session = {
      Unit = {
        Description = "A target that is enabled when starting Dwl";
        Requires = [ "graphical-session.target" "wm-services.target" ];
        PartOf = [ "graphical-session.target" ];
      };
    };

    home.file.".config/dwl/scripts/brightness.sh".source = ../qtile/config/brightness.sh;
    home.file.".config/dwl/scripts/print.sh".source = pkgs.writeShellScript "print.sh" ''
      #!/bin/sh -e

      out="$HOME/screens/$(date +%Y/%Y%m%d_%H%M%S).png"

      while getopts o:s arg; do case $arg in
        o) out="$OPTARG" ;;
        s) sel="$(slurp -o)" ;;
        ?|*) echo "usage: shot [-s] [-o out]" >&2; exit 1 ;;
      esac; done

      grim ''${sel:+ -g "$sel"} "$out"
      echo "$out"
      wl-copy -t image/png < "$out"
    '';
    home.file.".config/dwl/sequence-detector.config.json".source = ../qtile/config/sequence-detector.config.json;

    home.packages = [
      # Clipboard
      pkgs.wl-clipboard
      # PrintScreening
      pkgs.grim
      pkgs.slurp
      # pkgs.wldash
      pkgs.imv
      # DWL control
      inputs.self.packages.${pkgs.system}.dwlb
      inputs.self.packages.${pkgs.system}.dwlmsg
      pkgs.wlr-randr
      pkgs.wlrctl
      pkgs.wlopm
      pkgs.kanshi

      emacs-anywhere

      dwl
    ];

    programs = {
      swaylock = {
        enable = true;
        settings = {
          color = "808080";
          indicator-radius = 100;
          show-failed-attempts = true;
        };
      };
    };

    rutherther.programs.mako = {
      enable = true;

      config = with config.themes.default; {
        default = {
          font = "Ubuntu Mono 10";
          text-color = "#${foreground.text}FF";
          background-color = "#${background.primary}CC";

          border-size = 2;
          border-color = "#${foreground.active}FF";

          height = 250;
          margin = 5;
          padding = 24;
          max-icon-size = 16;
          layer = "overlay";

          default-timeout = 5000;
          ignore-timeout = 1;
        };

        sections = [
          {
            conditions = { mode = "idle"; };
            config = {
              # Sadly this affects even existing notifications.
              # It would be good if only those that actuallly came to
              # be in this mode were colored with this border color.
              border-color = "#${background.secondary}FF";
              ignore-timeout = 1;
              # mako overrides already existing notifications
              # if the default timeout is 0, whereas otherwise
              # it will keep the current one.
              default-timeout = 3 * 60 * 60 * 1000;
            };
          }

          {
            conditions = { urgency = "critical"; };
            config = {
              border-color = "#${urgent}FF";
            };
          }
        ];
      };
    };

    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${lib.getExe pkgs.swaylock} -Ff"; }
        { event = "lock"; command = "${lib.getExe pkgs.swaylock} -Ff"; }
      ];
      timeouts = [
        { timeout = 300; command = lib.getExe wlopmDisableScreens; resumeCommand = lib.getExe wlopmEnableScreens; }
        { timeout = 1800; command = "${lib.getExe' pkgs.systemd "systemctl"} suspend"; }
        { timeout = 30; command = "${lib.getExe' pkgs.mako "makoctl"} mode -a idle"; resumeCommand = "${lib.getExe' pkgs.mako "makoctl"} mode -r idle"; }
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        wlroots = {
          default = [ "gtk" "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          # https://github.com/labwc/labwc/discussions/1503
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      };
    };

    services.kanshi = {
      enable = true;
      systemdTarget = "wlr-session.target";
      settings = [
        {
          profile.name = "ntb";
          profile.outputs = [
            { criteria = "eDP-1"; status = "enable"; mode = "1920x1200"; position = "0,0"; }
          ];
        }
        {
          profile.name = "docked-1";
          profile.outputs = [
            { criteria = "DP-7"; position = "1920,0"; }
            { criteria = "DP-8"; position = "3840,0"; }
            { criteria = "DP-9"; position = "0,0"; }
            { criteria = "eDP-1"; status = "disable"; }
          ];
        }
        {
          profile.name = "docked-2";
          profile.outputs = [
            { criteria = "DP-10"; position = "1920,0"; }
            { criteria = "DP-11"; position = "3840,0"; }
            { criteria = "DP-12"; position = "0,0"; }
            { criteria = "eDP-1"; status = "disable"; }
          ];
        }
      ];
    };

    services.gammastep = {
      enable = true;
      temperature.night = 3000;
      latitude = 50.2332933;
      longitude = 14.3225926;
    };

    systemd.user.services.swayidle = {
      Install.WantedBy = lib.mkForce [ "wlr-session.target" ];
      Unit.PartOf = lib.mkForce [ "wlr-session.target" ];
    };

    systemd.user.services.gammastep = {
      Unit.After = lib.mkForce [ "wlr-session.target" ];
      Unit.PartOf = lib.mkForce [ "wlr-session.target" ];
      Install.WantedBy = lib.mkForce [ "wlr-session.target" ];
    };

    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/Rutherther/Waybar/commit/98b08880409cfd1277dc491b2f89de39a5107e50.patch";
            hash = "sha256-qnMnjL8ejGEO9SeIEclez1OISY7poKimr4Hu+ngKnxA=";
          })
        ];
      });
      systemd = {
        enable = true;
        target = "wlr-session.target";
      };
      style = ./waybar/style.css;
    };

    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    # xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  };
}
