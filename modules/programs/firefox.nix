{ inputs, config, lib, pkgs, ... }:

let
  nur = config.nur.repos;
in {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;

        extensions = with nur.rycee.firefox-addons; [
          # Basic
          proton-pass                # Password manager
          darkreader                 # Dark pages
          ublock-origin              # Ad block
          tridactyl                  # Vim-like keybindings

          # Containers
          multi-account-containers

          # Site specific
          # social fixer for facebook

          # UI
          text-contrast-for-dark-themes

          # Utility
          istilldontcareaboutcookies
          h264ify
          youtube-shorts-block

          # Privacy
          # Don't touch my tabs!
          # Don't track me google
          link-cleaner
          clearurls
          decentraleyes
          privacy-badger
        ];
      };
    };
  };
}
