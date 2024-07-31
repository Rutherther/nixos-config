{ config, lib, pkgs, ... }:

let
  cfg = config.desktopSessions;

  availableSessionsConfig = lib.filterAttrs (name: x: x.enable) cfg.instances;
  availableSessions = lib.attrNames availableSessionsConfig;
  sessionStartScripts = lib.map (x: x.startSession) (lib.attrValues availableSessionsConfig);

  desktopSessionType = lib.types.submodule ({ config, name, ... }: {
    options = {
      enable = lib.mkEnableOption "desktop session instance enable" // { default = true; };
      name = lib.mkOption {
        type = lib.types.str;
        default = name;
      };

      startSession = lib.mkOption {
        type = lib.types.package;
      };

      preStartHook = lib.mkOption {
        type = lib.types.str;
        default = "";
      };

      postStartHook = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          This is executed after the session is started.
          However, it's started outside of the session,
          so you won't get any environment variables from
          the session. If you need that, you need to utilize
          configuration, or flags of the session executable.

          There is $pid available to know the pid of the started
          session process.
        '';
      };
      exitHook = lib.mkOption {
        type = lib.types.str;
        default = ''
          systemctl stop --user graphical-session.target
        '';
      };

      executable = lib.mkOption {
        type = lib.types.path;
      };
      arguments = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      environment = lib.mkOption {
        type = lib.types.attrsOf (lib.types.oneOf [ lib.types.str lib.types.number ]);
      };
    };

    config = {
      startSession = pkgs.writeShellScript "start-${name}" ''
        ${lib.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs (name: value: "export ${name}='${value}'") config.environment))}

        ${config.preStartHook}
        ${config.executable} ${lib.concatStringsSep " " config.arguments} &
        pid=$!
        ${config.postStartHook}
        wait $pid
        ${config.exitHook}
      '';
    };
  });
in {
  options.desktopSessions = {
    instances = lib.mkOption {
      type = lib.types.attrsOf desktopSessionType;
      default = {};
    };

    enable = lib.mkEnableOption "desktop session configuration";

    selectSession = lib.mkOption {
      type = lib.types.path;
    };

    defaultSession = lib.mkOption {
      type = lib.types.str;
      default = "tty";
    };

    availableSessions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
    };

    sessionStartScripts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      readOnly = true;
    };

    sessionStartScriptsPath = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };

    autoStart = {
      enable = lib.mkEnableOption "auto start profile selection on tty login" // { default = true; };
      tty = lib.mkOption {
        type = lib.types.int;
        default = 1;
      };
      profileSelectContent = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config.desktopSessions = {
    inherit availableSessions;
    inherit sessionStartScripts;

    sessionStartScriptsPath = let
      sessionsCopy = (lib.concatStringsSep "\n" (lib.map (x: ''
            cp "${x.startSession}" "$out/bin/start-${x.name}"
          '') (lib.attrValues availableSessionsConfig)));
    in pkgs.runCommandNoCCLocal "session-start-scripts" {} ''
      mkdir -p $out/bin
      ${sessionsCopy}
    '';

    autoStart.profileSelectContent = ''
      if [[ "$(tty)" == "/dev/tty${builtins.toString cfg.autoStart.tty}" && "$(id -u)" != 0 ]]; then
        ${cfg.selectSession}
      fi
    '';

    selectSession = pkgs.writeShellScript "select-session" ''
      sessions=(${lib.concatStringsSep " " cfg.availableSessions})
      session_indices=(''${!sessions[@]})

      timeout=3
      selected="${cfg.defaultSession}" # default

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

      # tty name is treated specially. It just exits. Use default session of tty,
      # to not start any session.
      if [[ $selected == "tty" ]]; then
       exit
      fi

      ${cfg.sessionStartScriptsPath}/bin/start-$selected
    '';
  };
}
