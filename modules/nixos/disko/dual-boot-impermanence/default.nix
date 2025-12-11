# modules/nixos/disko/dual-boot-impermanence/disko-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.disko.dual-boot-impermanence;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.dual-boot-impermanence = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'dual-boot-generic', for namespace '${namespace}'.";

    blockDevice =
      mkOpt lib.types.str "/dev/sda" "specify block device. Could be disk-by-id as well.";
    efiPartSize =
      mkOpt lib.types.str "1G" "e.g.: '500M'. Default is best";
    windowsPartSize =
      mkOpt lib.types.str "150G" "e.g.: '250G'. This part is imperative, because linux will take rest if default. Otherwise, you will have calculate and provision.";
    linuxPartSize =
      mkOpt lib.types.str "100%" "e.g.: '250G'. Default is best";

    # rootPartSize =
    #   mkOpt lib.type.str "30G" "e.g.: '250G'. Default is best";
    # persistPartSize =
    #   mkOpt lib.types.str "100%" "Size of persistent storage partition";
  };
  config =
    mkIf cfg.enable {
    };
}
