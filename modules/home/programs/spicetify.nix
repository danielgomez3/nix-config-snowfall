{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.profiles.${namespace}.home.programs.spicetify;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.home.programs.spicetify = {
    enable = mkEnableOption "Enable Spicetify";
  };
  config = mkIf cfg.enable {
    programs.spicetify = let
    in {
      enable = true;
    };
  };
}
