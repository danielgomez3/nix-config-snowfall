# modules/nixos/disko/xxmodulexx/disko-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.disko.xxmodulexx;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.xxmodulexx = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'xxmodulexx', for namespace '${namespace}'.";
    blockDevice =
      mkOpt lib.types.str "/dev/sda" "specify block device";
  };
  config =
    mkIf cfg.enable {
    };
}
