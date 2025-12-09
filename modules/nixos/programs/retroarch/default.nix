# retroarch.nix
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
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.retroarch = {
    enable = mkEnableOption "Enable custom 'nixos', module 'retroarch', for namespace '${namespace}'.";
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
