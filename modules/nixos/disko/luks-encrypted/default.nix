# modules/nixos/disko/luks-encrypted/disko-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.disko.luks-encrypted;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.luks-encrypted = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'luks-encrypted', for namespace '${namespace}'.";
    dualBoot.enable = mkBoolOpt false "leave space in disk for dual boot (windows only tested)";
    blockDevice =
      mkOpt lib.types.str "" "specify block device. e.g. /dev/sda. device-by-id is valid too.";
    windowsPartSize =
      mkOpt lib.types.str "250G" "e.g.: '250G'. This part is imperative, because linux will take rest if default. Otherwise, you will have calculate and provision.";
    linuxPartSize =
      mkOpt lib.types.str "100%" "e.g.: '250G'. Default is best";
    efiPartSize =
      mkOpt lib.types.str "1G" "e.g.: '500M'. Default is best";
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.dualBoot.enable && cfg.linuxPartSize == "100%");
        message = ''
          When dualBoot.enable = true, an exact linuxPartSize must be specified!
          Example: linuxPartSize = "500G"
          This leaves space for Windows installation.
        '';
      }
      {
        assertion = cfg.blockDevice != "";
        message = ''
          blockDevice = "";
          Must specify block device!
        '';
      }
    ];
    disko.devices = {
      disk = {
        nvme0n1 = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                label = "boot";
                name = "ESP";
                size = "${cfg.efiPartSize}";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "defaults"
                  ];
                };
              };
              luks = {
                size = "${cfg.linuxPartSize}";
                label = "luks";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  extraOpenArgs = [
                    "--allow-discards"
                    "--perf-no_read_workqueue"
                    "--perf-no_write_workqueue"
                  ];
                  settings = {crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];};
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
                        swap.swapfile.size = "64G";
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
