{ config, lib, pkgs, location, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
  };

  accounts.email = {
    accounts = {
      ctu = {
        primary = true;
        thunderbird = {
          enable = true;
        };
        address = "bohacfr2@fel.cvut.cz";
        userName = "bohacfr2";
        realName = "František Boháček";
        imap = {
          host = "imap.fel.cvut.cz";
          port = 993;
        };
        smtp = {
          host = "smtpx.fel.cvut.cz";
          port = 465;
          tls = {
            enable = true;
          };
        };
      };
    };
  };
}
