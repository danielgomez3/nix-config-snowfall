# allow-sleep-then-hibernate.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.allow-sleep-then-hibernate;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.allow-sleep-then-hibernate = {
    enable = mkEnableOption "Enable custom 'nixos', module 'allow-sleep-then-hibernate', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
      };
    };
    profiles.${namespace}.my.nixos = {
      bundles = {
      };
      features = {
      };
      programs = {
      };
    };
    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };
}
