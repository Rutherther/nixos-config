{ config, lib, pkgs, user, location, ... }:

let 
  nur = config.nur.repos;
in {
  # services.udev.extraRules =
  #     ''ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr -c"'';
  services.autorandr = {
    enable = true;
  };

  home.packages = with pkgs; [
    nur.rutherther.rutherther-mpris-ctl
    nur.rutherther.rutherther-sequence-detector
  ];

  systemd.user.services = {
    mpris-ctld = {
      Unit = {
        Description = "Daemon for mpris-ctl cli, that will keep track of last playing media";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        ExecStart = "${nur.rutherther.rutherther-mpris-ctl}/bin/mpris-ctld";
      };
    };
  };

  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "reload-qtile" = "${pkgs.qtile}/bin/qtile cmd-obj -o cmd -f reload_config";
      };
    };
    profiles = {
      "desktop" = {
        fingerprint = {
          DVI-D-0 = "00ffffffffffff0009d1d978455400002b1a010380351e782e6c40a755519f27145054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c45000f282100001e000000ff0054414730333931303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e51204757323437300a200161020322f14f901f05140413031207161501061102230907078301000065030c002000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018000000000000000000000000000000000000000000f5";
          DisplayPort-0 = "00ffffffffffff0009d1e77801010101261e0104a5351e783a05f5a557529c270b5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff00455442394c3033373432534c30000000fd00324c1e5311010a202020202020000000fc0042656e51204757323438300a2001e002031cf14f901f041303120211011406071516052309070783010000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000000000000000008d";
          HDMI-A-0 = "00ffffffffffff0009d1e778455400000d1c010380351e782e0565a756529c270f5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff0058334a30303131303031510a20000000fd00324c1e5311000a202020202020000000fc0042656e51204757323438300a2001b0020322f14f901f04130312021101140607151605230907078301000065030c001000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000003";
        };
        config = {
          DVI-D-0 = {
            enable = true;
            crtc = 0;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.833";
            rate = "60.00";
          };
          DisplayPort-0 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.833";
            rate = "60.00";
          };
          HDMI-A-0 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "3840x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.833";
            rate = "60.00";
          };
        };
      };
      "virtual" = {
        fingerprint = {
          Virtual-1 = "00ffffffffffff0049143412000000002a180104a530197806ee91a3544c99260f5054210800e1c0d1c0d100a940b3009500818081405a4f80a072f22330e0395540e70011000018000000f7000a004082002820000000000000000000fd00327d1ea0ff010a202020202020000000fc0051454d55204d6f6e69746f720a019902030b00467d6560591f6100000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000000000000002f";
          Virtual-2 = "00ffffffffffff0049143412000000002a180104a5301b7806ee91a3544c99260f5054210800e1c0d1c0d100a940b300950081808140d25480a072382540e0395540e71211000018000000f7000a004082002820000000000000000000fd00327d1ea0ff010a202020202020000000fc0051454d55204d6f6e69746f720a01b002030b00467d6560591f6100000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000000000000002f";
        };
        config = {
          Virtual-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
          Virtual-2 = {
            enable = true;
            primary = false;
            position = "1920x0";
            mode = "1920x1080";
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
