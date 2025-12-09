# sops.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.sops;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.sops = {
    enable = mkEnableOption "Enable custom 'nixos', module 'sops', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
