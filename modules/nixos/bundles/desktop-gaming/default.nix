# desktop-gaming.nix
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
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.bundles.desktop-gaming = {
    enable = mkEnableOption "Enable custom 'nixos', module 'desktop-gaming', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      bundles = {
      };
      features = {
        minecraft-client.enable = true;
      };
      programs = {
        steam.enable = true;
      };
    };
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
        mangohud.enable = true;
      };
    };
  };
}
