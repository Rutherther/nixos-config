{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "ruther";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${pkgs.qtile}/bin/qtile start'";
      };
      gnome = {
        user = "ruther";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${pkgs.gnome.gnome-session}/bin/gnome-session'";
      };
    };
  };
}
