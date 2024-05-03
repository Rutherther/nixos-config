{ stdenv, fetchgit, pkg-config, wayland-scanner, wayland, wlroots }:

stdenv.mkDerivation {
  name = "dwlmsg";

  src = fetchgit {
    url = "https://codeberg.org/notchoc/dwlmsg";
    rev = "72668a5e5f2098f20831d83aa27bc4c3b8e3189d";
    hash = "sha256-AKmxN8NOgJj0rOItT1P7Ss4oRS/HQ7qdVx9Rh9VtVp8=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wlroots
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];
}
