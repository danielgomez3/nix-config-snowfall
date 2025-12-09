# openssh.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.openssh;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.openssh = {
    enable = mkEnableOption "Enable custom 'nixos', module 'openssh', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
