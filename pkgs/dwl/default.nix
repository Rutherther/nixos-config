{
  dwl,
  wayland-scanner,
  wayland-protocols,
  wayland,
  wlroots,
  libdrm,
  fcft,
  libffi,
  libdisplay-info,
  hwdata,
  lcms2,
  mesa,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchurl
}:

let
  wlroots-0_18 = wlroots.overrideAttrs (old: rec {
    version = "0.18.0";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = version;
      hash = "sha256-LiRnvu7qCbfSg+ONWVCtWwdzxxFZHfbgmy7zApCIW40=";
    };
    buildInputs = old.buildInputs ++ [
      lcms2
      hwdata
      libdisplay-info
    ];
  });
in ((dwl.override {
  wlroots = wlroots-0_18;
  conf = ./config.h;
}).overrideAttrs (oldAttrs: {
  version = "0.7";
  buildInputs = (oldAttrs.buildInputs or []) ++ [
    libdrm
    fcft
  ];
  src = fetchFromGitHub {
    owner = "Rutherther";
    repo = "dwl";
    rev = "a8e46f319f574876ce697a7097eb47a2080b1a87";
    hash = "sha256-AdQW9zqPn9+X6fIQHlZEgWK+k1EwWM8kW4h0wyzHfso=";
  };
}))
