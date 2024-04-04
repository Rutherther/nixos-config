{ stdenv, fetchFromGitHub, libsForQt5 }:

{
  sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;

    propagatedBuildInputs = [
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtsvg
    ];

    installPhase = ''
      mkdir -p $out/share/sddm/themes/sugar-dark

      cat << EOT >> theme.conf.user
        ForceHideCompletePassword="true"
      EOT

      cp -aR $src/* theme.conf.user $out/share/sddm/themes/sugar-dark/
    '';

    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
}
