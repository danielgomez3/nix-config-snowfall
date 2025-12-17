# modules/nixos/disko/luks-persist-usb/disko-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.disko.luks-persist-usb;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.luks-persist-usb = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'luks-persist-usb', for namespace '${namespace}'.";
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
          # imageSize = "40G";
          type = "disk";
          device = "/dev/disk/by-id/scsi-0WDC_SDINFDO4-128G_WDC";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                label = "boot";
                name = "ESP";
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "defaults"
                    "umask=0077"
                  ];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  # Remove FIDO2 settings and use password instead
                  passwordFile = config.sops.secrets."luks_password".path; # or use keyFile for persistent storage
                  # passwordFile = "/tmp/secret.key"; # or use keyFile for persistent storage
                  # Alternative: remove passwordFile and you'll be prompted during build
                  extraOpenArgs = [
                    "--allow-discards"
                    "--perf-no_read_workqueue"
                    "--perf-no_write_workqueue"
                  ];
                  content = {
                    type = "btrfs";
                    extraArgs = ["-L" "nixos" "-f"];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                      };
                      "/home" = {
                        mountpoint = "/home";
                        mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                      };
                      "/persist" = {
                        mountpoint = "/persist";
                        mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                      };
                      "/log" = {
                        mountpoint = "/var/log";
                        mountOptions = ["subvol=log" "compress=zstd" "noatime"];
                      };
                      "/swap" = {
                        mountpoint = "/swap";
                        swap.swapfile.size = "8G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;
  };
}
