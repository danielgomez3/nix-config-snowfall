# modules/nixos/disko/zfs-ephemeral/default.nix
# NOTE
# working but generally untested as of 2025-12-11

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
  cfg = config.profiles.${namespace}.my.nixos.disko.zfs-ephemeral;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.zfs-ephemeral = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'zfs-ephemeral', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    myVars.isEphemeral = true;
    profiles.${namespace}.my.nixos = {
      features = {
        persistence = enabled;
        # zfs-formatted = enabled;
      };
    };
    fileSystems."/persistent".neededForBoot = true;
    networking.hostId =
      builtins.substring 0 8
      (builtins.hashString "sha256" config.myVars.hostname);
      
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          rootFsOptions = {
            compression = "zstd";
            mountpoint = "none";
            "com.sun:auto-snapshot" = "false";
          };

          datasets = {
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              options."com.sun:auto-snapshot" = "true";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options = {
                "com.sun:auto-snapshot" = "false";
                atime = "off";
              };
            };
            # Change home to be part of the ephemeral root
            # Remove the separate home dataset by deleting this entire section!
            "safe/home" = { 
              type = "zfs_fs";
              mountpoint = "/home";  # ← This makes /home persistent!
              options."com.sun:auto-snapshot" = "true";
            };
            "safe/persistent" = {
              type = "zfs_fs";
              mountpoint = "/persistent";
              options."com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}
