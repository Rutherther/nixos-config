{ stdenv, pkg-config, wayland-scanner, wayland, wlroots, wayland-protocols, fcft, pixman, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "dwlb";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "dwlb";
    rev = "a30bb0398a468f3f59438dd441165953e9d6c0dd";
    hash = "sha256-z1br5vL6tWT+hbGtLzMLzuGj6mRcaBgchHiXlk5qOZc=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wlroots
    wayland-protocols
    fcft
    pixman
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];
}
