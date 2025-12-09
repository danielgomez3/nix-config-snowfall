# mySws.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.mySws;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.mySws = {
    enable = mkEnableOption "Enable custom 'nixos', module 'mySws', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
