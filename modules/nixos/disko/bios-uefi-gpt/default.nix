# bios-uefi-gpt.nix
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
  cfg = config.profiles.${namespace}.my.nixos.disko.bios-uefi-gpt;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.bios-uefi-gpt = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'bios-uefi-gpt', for namespace '${namespace}'.";
    dualBoot.enable = mkBoolOpt false "leave space in disk for dual boot (windows only tested)";
    blockDevice =
      mkOpt lib.types.str "" "specify block device. e.g. /dev/sda. device-by-id is valid too.";
    windowsPartSize =
      mkOpt lib.types.str "250G" "e.g.: '250G'. This part is imperative, because linux will take rest if default. Otherwise, you will have calculate and provision.";
    linuxPartSize =
      mkOpt lib.types.str "100%" "e.g.: '250G'. Default is best";
    efiPartSize =
      mkOpt lib.types.str "1G" "e.g.: '500M'. Default is best";
    swapPart.enable = mkBoolOpt false "Enable manual swap partition";
    swapPart.size =
      mkOpt lib.types.str "" "e.g.: 16G.";
  };
  config = mkIf cfg.enable {
    disko.devices = {
      disk = {
        main = {
          device = "${cfg.blockDevice}";
          type = "disk";
          content = {
            type = "gpt";
            partitions =
              (lib.optionalAttrs cfg.swapPart.enable {
                swap = {
                  size = "${cfg.swapPart.size}"; # Takes all remaining space
                  content = {
                    type = "filesystem";
                    format = "bcachefs";
                    mountpoint = "/";
                    mountOptions = ["compress=zstd"];
                  };
                };
              })
              // {
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
