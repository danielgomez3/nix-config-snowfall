# modules/nixos/programs/retroarch/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.retroarch;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.retroarch = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'retroarch', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (retroarch.withCores (cores:
        with cores; [
          genesis-plus-gx
          snes9x
          beetle-psx-hw
        ]))
    ];
  };
}
