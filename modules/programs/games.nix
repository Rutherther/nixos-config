#
# Gaming
# Steam + MC + Emulation
#
# Do not forget to enable Steam play for all title in the settings menu
#

{ config, pkgs, nur, lib, ... }:

let                                             # No longer required because of retroarch but let's keep it for testing purposes
  pcsx2 = pkgs.pcsx2.overrideAttrs (old: {      # PCSX2 runs way better on x11. This wrappers makes it use the correct GDK Backend
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
    postFixup = ''
      wrapProgram $out/bin/pcsx2 \
        --set GDK_BACKEND x11
    '';
  });
in
{
  environment.systemPackages = [
    pkgs.lunar-client
    pkgs.heroic
    pkgs.lutris
    pkgs.prismlauncher
    pkgs.retroarchFull
    pkgs.steam
    pcsx2
  ];

  programs = {                                  # Needed to succesfully start Steam
    steam = {
      enable = true;
    };
    gamemode.enable = true;                     # Better gaming performance
                                                # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
                                                # Lutris: General Preferences - Enable Feral GameMode
                                                #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];                                            # Use Steam for Linux libraries
}
