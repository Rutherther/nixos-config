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
          "beacon.enabled" = false;
          "browser.contentblocking.category" = "strict";

          "browser.newtabpage.enabled" = false; # Blank new tab page.
          "browser.startup.page" = 3; # Resume last session.
          "browser.tabs.closeWindowWithLastTab" = false;

          "browser.download.dir" = "${config.home.homeDirectory}/download";
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "signon.rememberSignons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

          "layout.css.prefers-color-scheme.content-override" = 2;
          "browser.uidensity" = 1; # Dense.
          "extensions.unifiedExtensions.enabled" = false; # Disable extensions symbol in bar
          "layout.css.devPixelsPerPx" = 1; # Default zoom?

          "media.ffmpeg.vaapi.enabled" = true;
          "gfx.webrender.all" = true;

          "network.IDN_show_punycode" = true;

          "permissions.default.shortcuts" = 3; # Don't steal my shortcuts!

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Privacy
          "browser.search.hiddenOneOffs" =
            "Google,Yahoo,Bing,Amazon.com,Twitter";
          "browser.send_pings" = false;
          "dom.battery.enabled" = false;
          "dom.security.https_only_mode" = true;
          "network.dns.disablePrefetch" = true;
          "geo.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false; # Do not resolve dns before clicking
          "network.prefetch-next" = false;
          "media.video_stats.enabled" = false;

          "network.http.referer.XOriginPolicy" = 2;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "network.http.referer.trimmingPolicy" = 1;

          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.firstparty.isolate" = true;

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
