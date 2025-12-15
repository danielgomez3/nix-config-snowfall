# modules/nixos/bundles/desktop-gaming/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.bundles.desktop-gaming;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.bundles.desktop-gaming = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'bundles', of module 'desktop-gaming', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      features = {
      };
      programs = {
        steam.enable = true;
        minecraft-launcher.enable = true;
        roblox.enable = true;
      };
    };
  };
}
