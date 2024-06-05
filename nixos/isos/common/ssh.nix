{ config, lib, pkgs, ... }:

let
  sshKeys = [
    # ThinkPad
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0mhvKW3dgLTGLGMgGdMgUFz14F16pRzSAH7IU/OssnYXmi+TlkXLakHtmNWLdb6IEEjS2od0iDW4I71awJjL/VqRSBBt/1t6ndM6M79pD6feU9uYaPMB20ORyZh5D+1zjWX4cFVlcfCQ2bUyV0D+VRoDrN/YWFhPU0XNMZjatqN8JNKljM0hwWt9OPuQdlwG5KnrbDPUn8gf6kZtfVWRamDrLLMKsGBeGw4oZVJLAPYJlaYps15VuySTw114n6/L16qpH/rUgDc5QFyrmtIE+l5wd5QteH489eG+8gAZfsbYj+pihek09rHch318ecsLYz/DxotB71BXsQH7nb0NPHk1VI8L6//meoCXNJc4Itbg7Jh2Oo/bDfYX9IyPEw2TRa3P+rbEO9N4vMxCgX+TuHNX/mTk0OFpJVu8AAwMlF2lalI8fpBKospP5PFoyIgrW7ab5dkQRGDTk+Bw1ed4KXMKl6RJejvDPuOAmpeOlosinz6OPj/rbR9hR48makxk= ruther@nixos"
    # Phone
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbHBbRaxwfOIyYYL6caWx8Afre8R+GRIgbX/zSGNmMq ruther@nord2-phone"
    # Server
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGE9SGfSVF61WEiPwJg7VR+hWCYwCERX59xIcIF/TJlg ruther@pallium"
  ];
in {
  services.openssh = {
    enable = true;
    settings = {
      PermitEmptyPasswords = false;
    };
  };

  users.users =
    (lib.genAttrs config.usersList (name: {
      openssh.authorizedKeys.keys = sshKeys;
    }));
}
