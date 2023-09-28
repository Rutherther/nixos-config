{ stdenv, config, lib, pkgs, ... }:

# Only udev rules...

stdenv.mkDerivation {
  name = "vivado-2023.1";

  nativeBuildInputs = [ pkgs.zlib ];
  buildInputs = [ pkgs.patchelf pkgs.procps pkgs.ncurses5 pkgs.makeWrapper ];

  src = ./.;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d/
    cp udev/* $out/lib/udev/rules.d/
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
}
