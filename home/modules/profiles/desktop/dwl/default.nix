{ lib, inputs, config, pkgs, ... }:

let
in {
  imports = [
  ];

  options = {
    profiles.desktop.dwl = {
      enable = lib.mkEnableOption "dwl";
    };
  };

  config = lib.mkIf config.profiles.desktop.dwl.enable {
    profiles.desktop.enable = true;
    systemd.user.targets.wlr-session = {
      Unit = {
        Description = "A target that is enabled when starting Dwl";
        Requires = [ "graphical-session.target" "wm-services.target" ];
        PartOf = [ "graphical-session.target" ];
      };
    };

    home.file.".sessions/start-dwl".source = pkgs.writeShellScript "start-dwl" ''
    export XDG_CURRENT_DESKTOP="wlroots"
    export GDK_BACKEND=wayland QT_QPA_PLATFORM=wayland
        dwl -s "${pkgs.writeShellScript "dwl-internal" ''
          dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
          systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
          systemctl start --user wlr-session.target
        ''}" &
      pid=$!
      # Put something here
      wait $pid
      systemctl stop --user graphical-session.target
    '';

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
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.grim
      pkgs.slurp
      # pkgs.wldash
      pkgs.imv
      inputs.self.packages.${pkgs.system}.dwlb
      inputs.self.packages.${pkgs.system}.dwlmsg
      pkgs.waylock
      pkgs.wlr-randr
      pkgs.wlrctl

      ((pkgs.dwl.override {
        conf = ./config.h;
      }).overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [
          pkgs.libdrm
          pkgs.fcft
        ];
        src = pkgs.fetchFromGitHub {
          owner = "Rutherther";
          repo = "dwl";
          rev = "3c1dea9f64747d325cd64a9ec53a831e38870763";
          hash = "sha256-yi1zvcA61xy9tXdGr7Y3vk8IIt54In9hTn9a9RcGH0U=";
        };
      }))
    ];

    xdg.portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-wlr ];
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };

    services.kanshi = {
      enable = true;
      systemdTarget = "wlr-session.target";
      profiles = {
        ntb = {
          outputs = [
            { criteria = "eDP-1"; mode = "1920x1200"; }
          ];
        };
        # docked-lid-open = {
        #   outputs = [
        #     { criteria = "DP-7"; position = "1920,0"; }
        #     { criteria = "DP-8"; position = "3840,0"; }
        #     { criteria = "DP-9"; position = "0,0"; }
        #     { criteria = "eDP-1"; mode = "1920x1200"; position = "1920,1080"; }
        #   ];
        # };
        docked-lid-closed = {
          outputs = [
            { criteria = "DP-7"; position = "1920,0"; }
            { criteria = "DP-8"; position = "3840,0"; }
            { criteria = "DP-9"; position = "0,0"; }
            { criteria = "eDP-1"; status = "disable"; }
          ];
        };
      };
    };

    services.gammastep = {
      enable = true;
      temperature.night = 3000;
      latitude = 50.2332933;
      longitude = 14.3225926;
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
