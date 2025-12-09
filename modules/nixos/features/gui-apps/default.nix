# gui-apps.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.gui-apps;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.gui-apps = {
    enable = mkEnableOption "Enable custom 'nixos', module 'gui-apps', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
