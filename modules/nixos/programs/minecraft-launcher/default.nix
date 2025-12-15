# modules/nixos/programs/minecraft-launcher/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.minecraft-launcher;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.minecraft-launcher = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'minecraft-launcher', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    environment.systemPackages = [pkgs.prismlauncher];
  };
}
