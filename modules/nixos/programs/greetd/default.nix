# greetd.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.greetd;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.greetd = {
    enable = mkEnableOption "Enable custom 'nixos', module 'greetd', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
