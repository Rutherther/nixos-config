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
