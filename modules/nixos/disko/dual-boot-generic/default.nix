# modules/nixos/disko/dual-boot-generic/disko-config.nix
# NOTE
# This is a hacky way of doing this. Research more elegant method.
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
  cfg = config.profiles.${namespace}.my.nixos.disko.dual-boot-generic;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.dual-boot-generic = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'dual-boot-generic', for namespace '${namespace}'.";
    blockDevice =
      mkOpt lib.types.str "/dev/sda" "specify block device. Could be disk-by-id as well.";
    efiPartSize =
      mkOpt lib.types.str "1G" "e.g.: '500M'. Default is best";
    windowsPartSize =
      mkOpt lib.types.str "150G" "e.g.: '250G'. This part is imperative, because linux will take rest if default. Otherwise, you will have calculate and provision.";
    linuxPartSize =
      mkOpt lib.types.str "100%" "e.g.: '250G'. Default is best";
  };
  config = mkIf cfg.enable {
    disko.devices = {
      disk = {
        main = {
          device = "${cfg.blockDevice}";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              # EFI System Partition
              ESP = {
                type = "EF00";
                size = "${cfg.efiPartSize}";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };

              # Linux root partition (ideally, rest of space)
              root = {
                start = "${cfg.windowsPartSize}"; # Leave this much empty for windows before you create Linux Part.

                size = "${cfg.linuxPartSize}"; # Takes all remaining space
                content = {
                  type = "filesystem";
                  format = "bcachefs";
                  mountpoint = "/";
                  mountOptions = ["compress=zstd"];
                };
              };
            };
          };
        };
      };
    };
  };
}
