# xxmodulenamexx.nix
{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.poopyplatform.stinkycategory.stankmodule;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.poopyplatform.stinkycategory.stankmodule = {
    enable = mkEnableOption "Enable custom poopyplatform module: stankmodule";
  };
  config =
    mkIf cfg.enable {
    };
}
