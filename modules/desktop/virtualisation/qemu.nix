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
        verbatimConfig = ''
         nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
        '';
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;        # USB passthrough
  };

  environment = {
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
