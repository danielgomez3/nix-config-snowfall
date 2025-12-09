# ly.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.ly;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.ly = {
    enable = mkEnableOption "Enable custom 'nixos', module 'ly', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    services.displayManager.ly = {
      enable = true;
    };
  };
}
