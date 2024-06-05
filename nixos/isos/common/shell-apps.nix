{ pkgs, config, ... }:

{
  environment.systemPackages = [
    # (pkgs.writeShellApplication "git-clone-nixos-config" { buildInputs = [ pkgs.git ]; } ''
    #   git clone https://github.com/Rutherther/nixos-config
    #   mkdir -p nixos-config/nixos/hosts/$1
    #   nixos-generate-config --dir nixos-config/nixos/hosts/$1 --root /mnt
    # '')

    (pkgs.writeShellApplication {
      name = "git-clone-nixos-config";
      text = ''
        git clone https://github.com/Rutherther/nixos-config
      '';
    })
    (pkgs.writeShellApplication {
      name = "copy-self";
      text = ''
        cp -r ${config.deps-inject.inputs.self} self
      '';
    })
    (pkgs.writeShellApplication {
      name = "link-self";
      text = ''
        ln -s ${config.deps-inject.inputs.self} self
      '';
    })
  ];
}
