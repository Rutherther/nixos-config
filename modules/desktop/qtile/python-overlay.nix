{nigpkgs, ...}:

{

  nixpkgs = {
    overlays = [
      (final: super: {
        pythonPackagesOverlays =
          (super.pythonPackagesOverlays or [])
          ++ [
            (_: pprev: {
              cairocffi = pprev.cairocffi.overridePythonAttrs (_: rec {
                pname = "cairocffi";
                version = "1.6.1";
                src = super.fetchPypi {
                  inherit pname version;
                  hash = "sha256-eOa75HNXZAxFPQvpKfpJzQXM4uEobz0qHKnL2n79uLc=";
                };
                format = "pyproject";
                postPatch = "";
                propagatedNativeBuildInputs = with super.python3Packages; [cffi flit-core];
              });
              pywlroots = pprev.pywlroots.overridePythonAttrs (_: rec {
                version = "0.16.4";
                src = super.fetchPypi {
                  inherit version;
                  pname = "pywlroots";
                  hash = "sha256-+1PILk14XoA/dINfoOQeeMSGBrfYX3pLA6eNdwtJkZE=";
                };
                buildInputs = with super; [libinput libxkbcommon pixman xorg.libxcb xorg.xcbutilwm udev wayland wlroots_0_16];
              });
              xcffib = pprev.xcffib.overridePythonAttrs (_: rec {
                pname = "xcffib";
                version = "1.4.0";
                src = super.fetchPypi {
                  inherit pname version;
                  hash = "sha256-uXfADf7TjHWuGIq8EkLvmDwCJSqGd6gMSwKVMz9StiQ=";
                };
                patches = [];
              });
              qtile = pprev.qtile.overridePythonAttrs (_: {
                version = ''2023.08.23''; # qtile
                src = super.fetchFromGitHub {
                  owner = "qtile";
                  repo = "qtile";
                  rev = ''9b2aff3b3d4607f3e782afda2ec2a061d7eba9f1''; # qtile
                  hash = ''sha256-20MO9eo2itF4zGLe9efEtE6c5UtAyQWKJBgwOSWBqAM=''; # qtile
                };
                prePatch = ''
                  substituteInPlace libqtile/backend/wayland/cffi/build.py \
                    --replace /usr/include/pixman-1 ${super.pixman.outPath}/include \
                    --replace /usr/include/libdrm ${super.libdrm.dev.outPath}/include/libdrm
                '';
                buildInputs = with super;
                  [
                    libinput
                    wayland
                    libxkbcommon
                    xorg.xcbutilwm
                    wlroots_0_16
                  ];
              });
              qtile-extras = pprev.qtile-extras.overridePythonAttrs (old: {
                version = ''2023.08.14''; # extras
                src = super.fetchFromGitHub {
                  owner = "elParaguayo";
                  repo = "qtile-extras";
                  rev = ''ed01fd8b94997b2a87eecb9bf48e424be91baf76''; # extras
                  hash = ''sha256-pIfaFIzM+skT/vZir7+fWWNvYcVnUnfXT3mzctqYvUs=''; # extras
                };
                checkInputs = (old.checkInputs or []) ++ [super.python3Packages.pytest-lazy-fixture];
                pytestFlagsArray = ["--disable-pytest-warnings"];
                disabledTests =
                  (old.disabledTests or [])
                  ++ [
                    "1-x11-currentlayout_manager1-55"
                    "test_githubnotifications_colours"
                    "test_githubnotifications_logging"
                    "test_githubnotifications_icon"
                    "test_githubnotifications_reload_token"
                    "test_image_size_horizontal"
                    "test_image_size_vertical"
                    "test_image_size_mask"
                    "test_widget_init_config"
                    "test_mpris2_popup"
                    "test_snapcast_icon"
                    "test_snapcast_icon_colour"
                    "test_snapcast_http_error"
                    "test_syncthing_not_syncing"
                    "test_syncthing_is_syncing"
                    "test_syncthing_http_error"
                    "test_syncthing_no_api_key"
                    "test_visualiser"
                    "test_no_icons"
                    "test_currentlayouticon_missing_icon"
                    "test_no_filename"
                    "test_no_image"
                  ];
              });
            })
          ];
        python3 = let
          self = super.python3.override {
            inherit self;
            packageOverrides = super.lib.composeManyExtensions final.pythonPackagesOverlays;
          };
        in
          self;
        python3Packages = final.python3.pkgs;
      })
    ];
  };
}
