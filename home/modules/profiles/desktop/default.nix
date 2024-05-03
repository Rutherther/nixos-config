{ config, lib, pkgs, ... }:

{
  imports = [
    ./qtile
    ./dwl
    ./gnome.nix
  ];

  options = {
    profiles.desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };

  config = lib.mkIf config.profiles.desktop.enable {
    home.file.".start-session".source = pkgs.writeShellScript "start-session" ''
      sessions=($(ls ~/.sessions))
      session_indices=(''${!sessions[@]})

      timeout=3
      selected="start-dwl" # default

      echo "Default session to start is $selected"

      echo "Available sessions:"
      for i in ''${!sessions[@]}; do
          echo "  $((i+1))) ''${sessions[$i]}"
      done
      echo "  q) Enter tty."

      echo -n "Choose session to start: "
      read -t"$timeout" -n1 user_input
      echo

      if [[ $user_input == "q" ]]; then
          exit
      elif [[ $user_input ]]; then
          user_input=$((user_input-1))
          echo $user_input
          echo ''${session_indices[@]}
          if [[ " ''${session_indices[@]} " =~ " $user_input " ]]; then
              selected="''${sessions[$user_input]}"
              echo "Got $user_input. Going to start $selected"
          else
              echo "Got unknown option. Exiting."
              exit
          fi
      else
          echo "Got no input, starting $selected"
      fi

      echo "Going to start $selected"

      exec "~/.sessions/$selected"

    '';

    programs = {
      bash = {
        enable = true;
        profileExtra =  ''
          if [[ "$(tty)" == "/dev/tty1" && "$(id -u)" != 0 ]]; then
            ~/.start-session
          fi
        '';
      };
      zsh = {
        enable = true;
        profileExtra = ''
          if [[ "$(tty)" == "/dev/tty1" && "$(id -u)" != 0 ]]; then
            ~/.start-session
          fi
        '';
      };
    };
  };
}
