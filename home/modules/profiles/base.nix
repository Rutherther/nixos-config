{ inputs, config, lib, pkgs, ... }:

let
  nur = import inputs.nur {
    nurpkgs = import inputs.nixpkgs { inherit (pkgs) system; };
    inherit pkgs;
  };
in {
  options = {
    profiles.base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf config.profiles.base.enable {
    home-config.startup.apps = [ (lib.getExe pkgs.firefox) ];

    home.activation = {
      noshellLink = {
        after = [ "writeBoundery" "createXdgUserDirectories" ];
        before = [];
        data = ''
          if [[ ! -f "$HOME/.config/shell" ]]; then
            ln -s ${lib.getExe pkgs.zsh} $HOME/.config/shell
          fi
        '';
      };
    };

    services = {
      gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-qt;
      };
    };

    home.packages = [
      pkgs.dmenu-wayland
    ];

    programs = {

      gpg = {
        enable = true;
      };

      password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
      };

      dircolors = {
        enable = true;
        settings = {
          OTHER_WRITABLE = "01;35"; # Make ntfs colors readable
        };
      };

      alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = "FiraCode Nerd Font";
            bold = { style = "Bold"; };
            size = 12;
          };
          # offset = {                            # Positioning
          #   x = -1;
          #   y = 0;
          # };
        };
      };

      foot = {
        enable = true;
        settings = {
          main = {
            font = "FiraCode Nerd Font:size=12";
          };
        };
      };

      starship = {
        enable = true;
      };

      zsh = {
        enable = true;
        autosuggestion = {
          enable = true;
        };
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        history.size = 100000;

        plugins = let
          inherit (pkgs) fetchFromGitHub;
        in [
          {
            name = "emacs";
            src = fetchFromGitHub {
              owner = "Flinner";
              repo = "emacs";
              rev = "7d12669fe2738ef98444d857f2bbeaf409de2b06";
              hash = "sha256-zqPSCziEJK32o9EzxzvhRRq5TRtj/daBEXd21XTsXsU=";
            };
          }
          {
            name = "zsh-vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
        ];

        initExtra = ''
            zstyle ':completion:*:*:*:*:*' menu select

            function exa-nixpkgs-derivation {
              nix run nixpkgs#eza -- --tree $(nix build nixpkgs#$1 --print-out-paths --out-link /tmp/$1)
            }

            mkreal() {
              cp $1 $1.bcp
              chmod +w $1.bcp
              mv $1.bcp $1
            }
        '';
      };

      firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            pkgs.browserpass
          ];
        };
        profiles = {
          default = {
            id = 0;
            name = "Default";
            isDefault = true;

            userChrome = ''
                #navigator-toolbox { font-family:Ubuntu !important }
            '';

            extensions = with nur.repos.rycee.firefox-addons; [
              # Basic
              proton-pass                # Password manager
              browserpass
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

              "full-screen-api.warning.timeout" = 0;

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

      # Email
      thunderbird = {
        enable = true;
        profiles = {
          default = {
            isDefault = true;
          };
        };
      };
    };

    accounts.email = {
      accounts = {
        ctu = {
          primary = true;
          thunderbird = {
            enable = true;
          };
          address = "bohacfr2@fel.cvut.cz";
          userName = "bohacfr2";
          realName = "František Boháček";
          imap = {
            host = "imap.fel.cvut.cz";
            port = 993;
          };
          smtp = {
            host = "smtpx.fel.cvut.cz";
            port = 465;
            tls = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
