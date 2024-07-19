{ config, inputs, lib, pkgs, ... }:

let
    trezor-udev-rules = pkgs.writeTextFile {
      name = "trezor-udev-rules";
      destination = "/etc/udev/rules.d/100-trezor.rules";
      text = ''
        # Trezor: The Original Hardware Wallet
        # https://trezor.io/
        #
        # Put this file into /etc/udev/rules.d
        #
        # If you are creating a distribution package,
        # put this into /usr/lib/udev/rules.d or /lib/udev/rules.d
        # depending on your distribution

        # Trezor
        SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

        # Trezor v2
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c0", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    ti-udev-rules = pkgs.writeTextFile {
      name = "tiva-c-launchpad-udev-rules";
      destination = "/etc/udev/rules.d/100-tiva-c.rules";
      text = ''
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0403",ATTRS{idProduct}=="a6d0",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0403",ATTRS{idProduct}=="a6d1",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0403",ATTRS{idProduct}=="6010",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1cbe",ATTRS{idProduct}=="00fd",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1cbe",ATTRS{idProduct}=="00ff",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef1",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef2",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef3",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef4",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0451",ATTRS{idProduct}=="f432",MODE:="600", TAG+="uaccess"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="0d28",ATTRS{idProduct}=="0204",MODE:="600", TAG+="uaccess"
        KERNEL=="hidraw*",ATTRS{busnum}=="*",ATTRS{idVendor}=="0d28",ATTRS{idProduct}=="0204",MODE:="600", TAG+="uaccess"
        ATTRS{idVendor}=="0451",ATTRS{idProduct}=="bef0",ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTRS{idVendor}=="0c55",ATTRS{idProduct}=="0220",ENV{ID_MM_DEVICE_IGNORE}="1"
        KERNEL=="ttyACM[0-9]*",MODE:="0600", TAG+="uaccess"
      '';
    };

    stlink-udev-rules = pkgs.writeTextFile {
      name = "stlink-udev-rules";
      destination ="/etc/udev/rules.d/100-stlink.rules";
      text = ''
        # ST-LINK V2
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv2_%n"

        # ST-LINK V2.1
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv2-1_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv2-1_%n"

        # ST-LINK V3
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3loader_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3_%n"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="600", TAG+="uaccess", SYMLINK+="stlinkv3_%n"
      '';
    };

    moonlander-udev-rules = pkgs.writeTextFile {
      name = "moonlander-udev-rules";
      destination = "/etc/udev/rules.d/100-moonlander.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", MODE:="600", TAG+="uaccess", SYMLINK+="stm32_dfu"
      '';
    };

    cfg = config.profiles.development;
in
{
  options = {
    profiles.development = {
      enable = lib.mkEnableOption "development";

      fpga.cables = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
      mcu.cables = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };

      keyboards = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };

    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages =
      lib.lists.optional (builtins.elem "st-link" cfg.mcu.cables) stlink-udev-rules ++
      lib.lists.optional (builtins.elem "tiva-c" cfg.mcu.cables) ti-udev-rules ++
      lib.lists.optional (builtins.elem "trezor" cfg.mcu.cables) trezor-udev-rules ++
      lib.lists.optional (builtins.elem "ise" cfg.fpga.cables) inputs.nix-fpga-tools.packages.${pkgs.system}.ise-udev-rules ++
      lib.lists.optional (builtins.elem "ise" cfg.fpga.cables) inputs.nix-fpga-tools.packages.${pkgs.system}.vivado-udev-rules ++
      lib.lists.optional (builtins.elem "moonlander" cfg.keyboards) moonlander-udev-rules;
  };
}
