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
  wayland-src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayland";
    repo = "wayland";
    rev = "1.23.0";
    hash = "sha256-oK0Z8xO2ILuySGZS0m37ZF0MOyle2l8AXb0/6wai0/w=";
  };

  libdrm-git = libdrm.overrideAttrs rec {
    pname = "libdrm";
    version = "2.4.122";

    src = fetchurl {
      url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.xz";
      hash = "sha256-2fUHm3d9/8qTAMzFaxCpNYjN+8nd4vrhEZQN+2KS8lE=";
    };
  };

  mesa-drm-git = mesa.override {
    libdrm = libdrm-git;
  };

  wayland-scanner-git = wayland-scanner.overrideAttrs {
    version = "1.23.0";
    patches = [];
    src = wayland-src;
  };

  wayland-git = wayland.overrideAttrs {
    version = "1.23.0";
    patches = [];
    src = wayland-src;
  };

  wayland-protocols-git = (wayland-protocols.override {
    wayland = wayland-git;
    wayland-scanner = wayland-scanner-git;
  }).overrideAttrs (old: rec {
    pname = "wayland-protocols";
    version = "1.36";

    src = fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/${pname}/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
      hash = "sha256-cf1N4F55+aHKVZ+sMMH4Nl+hA0ZCL5/nlfdNd7nvfpI=";
    };
  });

  wlroots-0_18 = (wlroots.override {
    wayland = wayland-git;
    wayland-scanner = wayland-scanner-git;
    wayland-protocols = wayland-protocols-git;
    mesa = mesa-drm-git;
  }).overrideAttrs (old: rec {
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
  wayland = wayland-git;
  wayland-protocols = wayland-protocols-git;
  wlroots = wlroots-0_18;
  wayland-scanner = wayland-scanner-git;
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
    rev = "366c7fc21f08ed3edca89810071d8c68fec952d1";
    hash = "sha256-rhPiq+Fd3axlwQHR46TYUX1wKKH5BvQ8vXSbExIcJPw=";
  };
}))
