{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.virtualisation;
in {
  options = {
    profiles.virtualisation = {
      enable = lib.mkEnableOption "virtualisation";

      qemu.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      podman.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.podman.enable {
      users.groups.podman.members = [ config.nixos-config.defaultUser ];

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.systemPackages = with pkgs; [
        podman-compose
      ];
    })
    (lib.mkIf cfg.qemu.enable {
      users.groups.libvirtd.members = [ "root" config.nixos-config.defaultUser ];
      users.groups.kvm.members = [ "root" config.nixos-config.defaultUser ];

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            ovmf.enable = true;
            ovmf.packages = [ pkgs.OVMFFull.fd ];
            verbatimConfig = ''
              nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
            '';
            swtpm.enable = true;
          };
        };
        spiceUSBRedirection.enable = true;        # USB passthrough
      };

      environment = {
        etc = {
          "ovmf/edk2-x86_64-secure-code.fd" = {
            source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
          };

          "ovmf/edk2-i386-vars.fd" = {
            source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
          };
        };

        systemPackages = with pkgs; [
          virt-manager
          virt-viewer
          qemu
          OVMF
          gvfs # Used for shared folders between Linux and Windows
          swtpm
        ];
      };

      services = { # Enable file sharing between OS
      gvfs.enable = true;
      };
    })
  ]);

}
