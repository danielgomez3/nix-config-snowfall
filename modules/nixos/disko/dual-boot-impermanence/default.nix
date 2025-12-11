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
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'dual-boot-impermanence', for namespace '${namespace}'.";
    blockDevice =
      mkOpt lib.types.str "/dev/sda" "specify block device";
    persistentStorageSize =
      mkOpt lib.types.str "50G" "Size of persistent storage partition";
  };
  config = mkIf cfg.enable {
    # modules/nixos/disko/dual-boot-generic/disko-config.nix
    disko.devices = {
      disk = {
        main = {
          device = cfg.blockDevice;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              # EFI System Partition (shared by both OSes)
              ESP = {
                priority = 1;
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };

              # Windows partition (first 230GB)
              windows = {
                priority = 2;
                size = "149G";
                type = "0700"; # Windows NTFS/HPFS
                # No mountpoint - Windows handles this
              };

              # Root partition (ephemeral)
              root = {
                priority = 3;
                size = "20G"; # Will be reduced by swap and persist
                content = {
                  type = "filesystem";
                  format = "bcachefs";
                  mountpoint = "/";
                  mountOptions = ["compress=zstd"];
                };
              };

              # Optional: Swap partition
              # swap = {
              #   priority = 4;
              #   size = "16G";
              #   content = {
              #     type = "swap";
              #     resumeDevice = true;
              #   };
              # };

              # Persistent storage partition
              persist = {
                priority = 4;
                size = "100%"; # e.g., "50G"
                content = {
                  type = "filesystem";
                  format = "ext4"; # Use ext4 for stability with impermanence
                  mountpoint = "/persist";
                  mountOptions = ["defaults"];
                };
              };
            };
          };
        };
      };
    };
  };
}
