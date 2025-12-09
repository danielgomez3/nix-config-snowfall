# music.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.music;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.music = {
    enable = mkEnableOption "Enable custom 'nixos', module 'music', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.musescore
      pkgs.muse-sounds-manager
    ];
  };
}
