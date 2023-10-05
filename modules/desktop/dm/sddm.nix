{ config, lib, pkgs, ... }:

let
  themes = pkgs.callPackage ./sddm-themes/sugar-dark.nix {};
  xsecurelock = (pkgs.xsecurelock.overrideAttrs(attrs: {
      postInstall = attrs.postInstall or "" + ''
        wrapProgram $out/bin/xsecurelock --set XSECURELOCK_COMPOSITE_OBSCURER 0
      '';
    }));
in {
  environment.systemPackages = with pkgs; [
    themes.sddm-sugar-dark

    # Dependencies of sugar dark theme
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtsvg
  ];

  programs = {
    xss-lock = {
      enable = true;
      lockerCommand = "${xsecurelock}/bin/xsecurelock";
    };
  };

  services = {
    xserver = {
      displayManager.sddm = {
        enable = true;
        theme = "sugar-dark";
      };
    };
  };
}
