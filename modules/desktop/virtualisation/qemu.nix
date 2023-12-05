#
# Qemu/KVM with virt-manager 
#

{ config, pkgs, user, ... }:

{
  users.groups.libvirtd.members = [ "root" "${user}" ];
  users.groups.kvm.members = [ "root" "${user}" ];

  virtualisation = {
    libvirtd = {
      enable = true;                          # Virtual drivers
      #qemuPackage = pkgs.qemu_kvm;           # Default
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
      gvfs                                    # Used for shared folders between Linux and Windows
      swtpm
    ];
  };

  services = {                                # Enable file sharing between OS
    gvfs.enable = true;
  };
}
