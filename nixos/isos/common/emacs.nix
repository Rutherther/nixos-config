{ lib, pkgs, ... }:

{
  environment.systemPackages = [
    ((pkgs.emacs.override {
      withNativeCompilation = false;
    }).pkgs.withPackages(epkgs: [
      epkgs.vterm
      epkgs.sqlite
      epkgs.treesit-grammars.with-all-grammars
    ]))
  ];
}
