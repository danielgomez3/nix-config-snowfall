# modules/__platform__/__category__/__module__/default.nix
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
  cfg = config.profiles.${namespace}.my.__platform__.__category__.__module__;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.__platform__.__category__.__module__ = {
    enable = mkBoolOpt false "Enable custom module for platform '__platform__', of category '__category__', of module '__module__', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.home = {
    # };
  };
}
