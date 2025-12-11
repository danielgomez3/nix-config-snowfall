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
    windowsPartSize =
      mkOpt lib.type.str "250G" "e.g.: '250G'. This part is imperative, because linux will take rest if default. Otherwise, you will have calculate and provision.";
    linuxPartSize =
      mkOpt lib.type.str "100%" "e.g.: '250G'. Default is best";
    efiPartSize =
      mkOpt lib.type.str "1G" "e.g.: '50M'. Default is best";
  };
  config =
    mkIf cfg.enable {
    };
}
