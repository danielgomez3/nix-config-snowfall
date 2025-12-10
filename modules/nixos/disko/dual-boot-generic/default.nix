# modules/nixos/disko/dual-boot-generic/disko-config.nix
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
      mkOpt lib.types.str "/dev/sda" "specify block device";
  };
  config = mkIf cfg.enable {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/nvme0n1"; # Change this to your actual disk
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              # EFI System Partition (shared by both OSes)
              ESP = {
                type = "EF00";
                # size = "500M";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot"; # or "/efi"
                  mountOptions = ["umask=0077"];
                };
              };

              # Linux root partition - starts after Windows space
              root = {
                # Reserve 100GB at the beginning for Windows
                start = "230G"; # Adjust this size based on your needs
                size = "100%"; # Take all remaining space for whatever you want (NixOS installation)
                content = {
                  type = "filesystem";
                  format = "bcachefs"; # or ext4, btrfs, etc.
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
