{ pkgs, ... }:

let
  mpris-ctl = pkgs.callPackage ../../pkgs/rutherther/mpris-ctl.nix {};
  sequence-detector = pkgs.callPackage ../../pkgs/rutherther/sequence-detector.nix {};
in {
  home.packages = [
    sequence-detector
    mpris-ctl
  ];

  systemd.user.services = {
    mpris-ctld = {
      Unit = {
        Description = "Daemon for mpris-ctl cli, that will keep track of last playing media";
        PartOf = [ "qtile-services.target" ];
      };

      Install = {
        WantedBy = [ "qtile-services.target" ];
      };

      Service = {
        ExecStart = "${mpris-ctl}/bin/mpris-ctld";
      };
    };
  };

}
