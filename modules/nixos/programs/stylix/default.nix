# stylix.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.stylix;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.stylix = {
    enable = mkEnableOption "Enable custom 'nixos', module 'stylix', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
