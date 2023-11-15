{ stdenv, config, lib, stable, pkgs, vivadoPath, ... }:

stable.buildFHSEnv {
  name = "vivado-wrapped";

  targetPkgs = pkgs: with pkgs; [
    coreutils
    stdenv.cc.cc
    ncurses5
    ncurses
    zlib
    xorg.libX11
    xorg.libXrender
    xorg.libxcb
    xorg.libXext
    xorg.libXtst
    xorg.libXi
    freetype
    gtk2
    glib
    libxcrypt-legacy
    gperftools
    glibc.dev
    fontconfig
    liberation_ttf
  ];

  runScript = "${vivadoPath}";
}
