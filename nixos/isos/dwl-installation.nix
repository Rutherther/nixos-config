{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (config.deps-inject.inputs) self;

  dwl-startup = pkgs.writeShellScript "dwl-startup" ''
    exec &<-
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
    systemctl start --user dwl-session.target
  '';

  dwl-start = pkgs.writeShellScript "dwl-start" ''
    export XDG_CURRENT_DESKTOP=wlroots XDG_BACKEND=wayland QT_QPA_PLATFORM=wayland MOZ_ENABLE_WAYLAND=1 _JAVA_AWT_WM_NONREPARENTING=1
    @dwl@ -s "${dwl-startup}"
    systemctl stop --user dwl-session.target
  '';
in {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
    ./common
  ];

  services.xserver.enable = lib.mkForce false;

  environment.systemPackages = [
    # Clipboard
    pkgs.cliphist
    pkgs.wl-clipboard
    # PrintScreening
    pkgs.grim
    pkgs.slurp
    # pkgs.wldash
    pkgs.imv
    # DWL control
    self.packages.${pkgs.system}.dwlb
    self.packages.${pkgs.system}.dwlmsg
    pkgs.wlr-randr
    pkgs.wlrctl
    pkgs.wlopm

    pkgs.rofi-wayland

    (
      pkgs.symlinkJoin {
        name = "dwl";
        paths = [ self.packages.${pkgs.system}.dwl ];
        postBuild = ''
          dwlPath=$(readlink $out/bin/dwl)
          cp -f ${dwl-start} $out/bin/dwl
          substituteInPlace $out/bin/dwl \
            --replace-fail "@dwl@" "$dwlPath"
        '';
      }
    )
  ];

  boot.plymouth.enable = lib.mkForce false;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  programs.nm-applet.enable = true;

  systemd.user.targets.dwl-session = {
    requires = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
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
  };

  systemd.user.tmpfiles.rules = [
    "L+ %h/.config/waybar/style.css - - - - ${self + "/home/modules/profiles/desktop/dwl/waybar/style.css"}"
    "L+ %h/.config/waybar/config.jsonc - - - - ${self + "/home/modules/profiles/desktop/dwl/waybar/config.jsonc"}"
  ];
}
