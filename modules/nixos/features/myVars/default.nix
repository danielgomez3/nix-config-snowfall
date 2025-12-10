# modules/nixos/features/myVars/default.nix
# TODO: you're not really enabling anything
{
  lib,
  pkgs,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  config,
  ...
}: let
  cfg = config.profiles.${namespace}.my.nixos.features.myVars;
  inherit (lib) mkEnableOption mkIf;
in {
  # OPTIONS section - defined unconditionally
  options.profiles.${namespace}.my.nixos.features.myVars = {
    enable = mkEnableOption "Enable custom module for platform 'nixos', of category 'features', of module 'myVars', for namespace '${namespace}'.";
  };

  # Define myVars options at the top level
  options.myVars = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "error";
      description = "The username for this specific machine.";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "error";
      description = "The hostname for this specific machine.";
    };
    isHardwareLimited = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is the machine hardware limited?";
    };
    isSyncthingServer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is the machine a Syncthing Server?";
    };
    isSyncthingClient = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is the machine a Syncthing Client?";
    };
    ports.mc = lib.mkOption {
      type = lib.types.port;
      default = 25565;
      description = "Minecraft server port";
    };
    isAMD = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Does the machine have an AMD GPU?";
    };
    isINTEL = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Does the machine have an INTEL GPU?";
    };
    isNVIDIA = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Does the machine have an NVIDIA GPU?";
    };
  };

  #  NOTE: This requires that these variables NEED to be set? Somewhere at least.
  config = mkIf cfg.enable {
    # Here you can set DEFAULT values for myVars if needed
    myVars = {
      # username = "daniel";  # Default username
      # hostname = "laptop";  # Default hostname
      # etc...
    };
  };
}
