#
# Nix setup using Home-manager
#
# flake.nix
#   └─ ./nix
#       ├─ default.nix
#       └─ pacman.nix *
#

{ config, pkgs, inputs, nixgl, user, location, ... }:

{
  imports =
    (import ../modules/editors/home.nix) ++
    # (import ../modules/programs/home.nix) ++ # Some problems with alacritty, see nixGL, but still, the .desktop files are not great
    (import ../modules/shell/home.nix);

  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [
      # Fonts
      carlito                                 # NixOS
      vegur                                   # NixOS
      source-code-pro
      jetbrains-mono
      font-awesome                            # Icons
      corefonts                               # MS
      (nerdfonts.override {                   # Nerdfont Icons override
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  xdg = {
    enable = true;
    systemDirs.data = [ "/home/${user}/.nix-profile/share" ]; # Will add nix packages to XDG_DATA_DIRS and thus accessible from the menus.
  };

  nix = {                                               # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;                       # Optimise syslinks
    };
    package = pkgs.nixFlakes;                           # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.
}
