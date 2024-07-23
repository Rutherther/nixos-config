{ config, lib, pkgs, ... }:

let
  cfg = config.rutherther.programs.mako;

  inherit (lib) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) str package number path attrsOf listOf oneOf submodule;

  configOptionType = oneOf [ str number ];
  configOptionsType = attrsOf configOptionType;
  mapConfigOptions = options: lib.mapAttrsToList (name: value: "${name}=${builtins.toString value}") options;
  sectionsType = submodule ({ config, ... }: {
    options = {
      conditions = mkOption {
        type = configOptionsType;
        description = "The conditions for current section.";
        example = {
          urgency = "critical";
        };
      };
      config = mkOption {
        type = configOptionsType;
        description = "Options to configure for the specified condition.";
        example = {
          border-color = "#FFFFFFFF";
        };
      };
      configText = mkOption {
        type = str;
        readOnly = true;
      };
    };

    config = {
      configText = ''[${lib.concatStringsSep " " (mapConfigOptions config.conditions)}]
${lib.concatStringsSep "\n" (mapConfigOptions config.config)}'';
    };
  });

  sectionsConfigs = lib.lists.map (section: section.configText) cfg.config.sections;
in {
  options.rutherther.programs.mako = {
    enable = mkEnableOption "Program - simple wayland notification daemon";

    package = mkPackageOption pkgs "mako" {};

    config.default = mkOption {
      type = configOptionsType;
      description = ''
        Text for the configuration file.
      '';
    };

    config.sections = mkOption {
      type = listOf sectionsType;
      description = "Sections to append to the config file. These apply only if conditions for those are satisfied.";
    };

    configFile = mkOption {
      type = package;
      readOnly = true;
      description = "Resulting file with the configuration text.";
    };

    configText = mkOption {
      type = str;
      readOnly = true;
      description = ''
        Resulting text of the configuration file.
      '';
    };

    dbusFile = mkOption {
      type = path;
      description = "D-Bus service file";
    };
  };

  config.rutherther.programs.mako = {
    configText = lib.concatStringsSep "\n" ((mapConfigOptions cfg.config.default) ++ sectionsConfigs) + "\n";
    configFile = pkgs.writeText "mako-config" cfg.configText;
    dbusFile = "${cfg.package}/share/dbus/fr.emersion.mako.service";
  };
}
