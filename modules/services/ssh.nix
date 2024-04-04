{ config, ... }:

{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.${config.nixos-config.defaultUser}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCLdKvP+WQmsoJebj4x0o8k/RniDpYDv3H+b+PWByChKPq4ThEnpL6P4sr0dpZ4NbWmDT9YPGuDEyZRxhrIerUKw+z8Jm32b8FeeYcEdoBlZTBz4WuN7G9FkDIYdqBYdnUaWh8/KeuZbUp/jB/d1Uv8rBdPSML1JlUPg8U/Z5Oky68LYUO60DfLoQZ+qD5AeTw4zPRACA5OOJj20eIDhiXKyp60eTXAiwrfC2RZJWURc4i92Oforua3OZEZfL1Z+xOjAhbKymPZIzKuzIIIVP/abnWv3b/shCCrR70wuZZ6QleY+DTcNsburmDfUP+3f+C1fF3mg6loZaGokGMwKtNI/0UVWHQW5BPkWfvkQmsW4jl02P174IlAGwvEkhTfBzmuaPKuf+0D+rJH+1FengEFmAPhaN6WIMFYGTScbOn46BS8v3oWhW5A+CQ1pMA9myu1fDr7WKrNCDdW9X398ByKA88OpEOU+vQcwgg6EPb/SuAlFDYBSgz0TX6IGl4demc= ruther@ntb-nixos"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0mhvKW3dgLTGLGMgGdMgUFz14F16pRzSAH7IU/OssnYXmi+TlkXLakHtmNWLdb6IEEjS2od0iDW4I71awJjL/VqRSBBt/1t6ndM6M79pD6feU9uYaPMB20ORyZh5D+1zjWX4cFVlcfCQ2bUyV0D+VRoDrN/YWFhPU0XNMZjatqN8JNKljM0hwWt9OPuQdlwG5KnrbDPUn8gf6kZtfVWRamDrLLMKsGBeGw4oZVJLAPYJlaYps15VuySTw114n6/L16qpH/rUgDc5QFyrmtIE+l5wd5QteH489eG+8gAZfsbYj+pihek09rHch318ecsLYz/DxotB71BXsQH7nb0NPHk1VI8L6//meoCXNJc4Itbg7Jh2Oo/bDfYX9IyPEw2TRa3P+rbEO9N4vMxCgX+TuHNX/mTk0OFpJVu8AAwMlF2lalI8fpBKospP5PFoyIgrW7ab5dkQRGDTk+Bw1ed4KXMKl6RJejvDPuOAmpeOlosinz6OPj/rbR9hR48makxk= ruther@desktop-nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbHBbRaxwfOIyYYL6caWx8Afre8R+GRIgbX/zSGNmMq ruther@nord2-phone"
  ];
}
