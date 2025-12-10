# modules/home/programs/eza/default.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.eza;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.eza = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'eza', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      colors = "auto";
      enableZshIntegration = true;
      enableBashIntegration = true;
      git = true;
      icons = "auto";
    };
  };
}
