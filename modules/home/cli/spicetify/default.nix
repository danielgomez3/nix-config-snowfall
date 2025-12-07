{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.cli.spicetify;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.cli.spicetify = {
    enable = mkEnableOption "Enable Spicetify";
  };
  config = mkIf cfg.enable {
    programs.spicetify = let
    in {
      enable = true;
    };
  };
}
