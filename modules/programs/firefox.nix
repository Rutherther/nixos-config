{ inputs, config, lib, nixpkgs, pkgs, ... }:

let
  nur = config.nur.repos;
  buildFirefoxXpiAddon = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;
  my-nur = import (builtins.fetchTarball {
    url = "https://github.com/Rutherther/nur-pkgs/archive/179f884ebb068f1803bd54647aee1f672b90db49.tar.gz";
    sha256 = "06kx9pn0682gn1r4kfhjbsg3b80gp4wpp8mp0p8v47zhbcvwqka6";
  }) { inherit pkgs; };
in {
  nixpkgs.overlays = [
    my-nur.overlays.firefoxpwa
    my-nur.overlays.firefox-native-messaging
  ];

  home.packages = [
    pkgs.firefoxpwa
  ];

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;

        userChrome = ''
          #navigator-toolbox { font-family:Ubuntu !important }
        '';

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
          link-cleaner
          clearurls
          decentraleyes
          privacy-badger
          skip-redirect

          # Paywalls
          # bypass-paywalls-clean
        ];

        settings = {
          "browser.newtabpage.enabled" = false; # Blank new tab page.
          "browser.startup.page" = 3; # Resume last session.
          "browser.tabs.closeWindowWithLastTab" = false;
          # Fully disable Pocket. See
          # https://www.reddit.com/r/linux/comments/zabm2a.
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "0.0.0.0";
          "extensions.pocket.loggedOutVariant" = "";
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.onSaveRecs" = false;
          "extensions.pocket.onSaveRecs.locales" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "0.0.0.0";
          "browser.newtabpage.activity-stream.pocketCta" = "";
          "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
        };
      };
    };
  };
}
