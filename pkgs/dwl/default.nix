{ dwl, libdrm, fcft, fetchFromGitHub }:

((dwl.override {
  conf = ./config.h;
}).overrideAttrs (oldAttrs: {
  buildInputs = (oldAttrs.buildInputs or []) ++ [
    libdrm
    fcft
  ];
  src = fetchFromGitHub {
    owner = "Rutherther";
    repo = "dwl";
    rev = "8c82c67f151c78b6bbe895f4831b20e6d7875450";
    hash = "sha256-02j6T66gzYXkFql2NffujNJPQsaEFm00i+o4aazCn8U=";
  };
}))
