{ config, lib, pkgs, user, location, ... }:

let
  nur = config.nur.repos;
in {
  # services.udev.extraRules =
  #     ''ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr -c"'';
  services.autorandr = {
    enable = true;
  };
  systemd.user.services.autorandr = lib.mkIf config.services.autorandr.enable {
    Unit.PartOf = lib.mkForce [ "qtile-services.target" ];
    Install.WantedBy = lib.mkForce [ "qtile-services.target" ];
  };

  home.packages = with pkgs; [
    nur.rutherther.rutherther-mpris-ctl
    nur.rutherther.rutherther-sequence-detector
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
        ExecStart = "${nur.rutherther.rutherther-mpris-ctl}/bin/mpris-ctld";
      };
    };
  };

  systemd.user.targets.qtile-services = {
    Unit = {
      Description = "A target that is enabled when starting Qtile";
      Requires = [ "graphical-session.target" ];
    };
  };

  programs.autorandr = {
    enable = true;
    profiles = {
      "home-docked" = {
        fingerprint = {
          "DP-7" = "00ffffffffffff0009d1e77801010101261e0104a5351e783a05f5a557529c270b5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff00455442394c3033373432534c30000000fd00324c1e5311010a202020202020000000fc0042656e51204757323438300a2001e002031cf14f901f041303120211011406071516052309070783010000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000000000000000008d";
          "DP-8" = "00ffffffffffff0009d1e778455400000d1c0104a5351e783a0565a756529c270f5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff0058334a30303131303031510a20000000fd00324c1e5311010a202020202020000000fc0042656e51204757323438300a20017d02031cf14f901f041303120211011406071516052309070783010000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000000000000000008d";
          "DP-9" = "00ffffffffffff0009d1d978455400002b1a010380351e782e6c40a755519f27145054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c45000f282100001e000000ff0054414730333931303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e51204757323437300a200161020322f14f901f05140413031207161501061102230907078301000065030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000005";
        };
        config = {
          DP-9 = {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
          };
          DP-7 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
          };
          DP-8 = {
            enable = true;
            position = "3840x0";
            mode = "1920x1080";
          };
          eDP-1 = {
            enable = false;
          };
        };
      };
      "home-internal" = {
        fingerprint = {
          "DP-7" = "00ffffffffffff0009d1e77801010101261e0104a5351e783a05f5a557529c270b5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff00455442394c3033373432534c30000000fd00324c1e5311010a202020202020000000fc0042656e51204757323438300a2001e002031cf14f901f041303120211011406071516052309070783010000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000000000000000008d";
          "DP-8" = "00ffffffffffff0009d1e778455400000d1c0104a5351e783a0565a756529c270f5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff0058334a30303131303031510a20000000fd00324c1e5311010a202020202020000000fc0042656e51204757323438300a20017d02031cf14f901f041303120211011406071516052309070783010000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000000000000000008d";
          "DP-9" = "00ffffffffffff0009d1d978455400002b1a010380351e782e6c40a755519f27145054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c45000f282100001e000000ff0054414730333931303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e51204757323437300a200161020322f14f901f05140413031207161501061102230907078301000065030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000005";
          "eDP-1" = "00ffffffffffff0009e5660b000000001a200104a51e137807e957a7544c9a26115457000000010101010101010101010101010101019c3e80c870b03c40302036002ebc1000001a163280c870b03c40302036002ebc1000001a000000fd001e3c4c4c10010a202020202020000000fe004e4531343057554d2d4e36470a00f7";
        };

        config = {
          DP-9 = {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
          };
          DP-7 = {
            enable = true;
            position = "1920x0";
            mode = "1920x1080";
          };
          DP-8 = {
            enable = true;
            position = "3840x0";
            mode = "1920x1080";
          };
          eDP-1 = {
            enable = true;
            primary = true;
            position = "1920x1080";
            mode = "1920x1200";
          };
        };
      };
      "notebook" = {
        fingerprint = {
          "eDP-1" = "00ffffffffffff0009e5660b000000001a200104a51e137807e957a7544c9a26115457000000010101010101010101010101010101019c3e80c870b03c40302036002ebc1000001a163280c870b03c40302036002ebc1000001a000000fd001e3c4c4c10010a202020202020000000fe004e4531343057554d2d4e36470a00f7";
        };
        config = {
          eDP-1 = {
            enable = true;
            # crtc = 0;
            primary = true;
            position = "0x0";
            mode = "1920x1200";
            # gamma = "1.0:0.909:0.833";
            # rate = "60.00";
          };
        };
      };
    };
  };

  xdg.configFile."qtile/config.py".source = ./config/config.py;
  xdg.configFile."qtile/bluetooth.py".source = ./config/bluetooth.py;
  xdg.configFile."qtile/mpris2widget.py".source = ./config/mpris2widget.py;
  xdg.configFile."qtile/tasklist.py".source = ./config/tasklist.py;
  xdg.configFile."qtile/xmonadcustom.py".source = ./config/xmonadcustom.py;
  xdg.configFile."qtile/sequence-detector.config.json".source = ./config/sequence-detector.config.json;

  xdg.configFile."qtile/nixenvironment.py".text = ''
from string import Template
import os

setupLocationRef = Template("${location}")
configLocationRef = Template("${location}/modules/desktop/qtile/config")

setupLocation = setupLocationRef.substitute(os.environ)
configLocation = configLocationRef.substitute(os.environ)

sequenceDetectorExec = "sequence_detector -c /home/${user}/.config/qtile/sequence-detector.config.json "
  '';
}
