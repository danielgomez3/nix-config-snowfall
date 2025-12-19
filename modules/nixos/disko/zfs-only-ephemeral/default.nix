# modules/nixos/disko/zfs-only-ephemeral/disko-config.nix
# NOTE
# /home is decidedly not ephemeral here. Maybe change that.
# TODO
# re-enable the docker pool for server machine so docker persists (?)!
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
  cfg = config.profiles.${namespace}.my.nixos.disko.zfs-only-ephemeral;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt genHostId;
in {
  options.profiles.${namespace}.my.nixos.disko.zfs-only-ephemeral = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'zfs-only-ephemeral', for namespace '${namespace}'.";
    dualBoot.enable = mkBoolOpt false "leave space in disk for dual boot (windows only tested)";
    blockDevice =
      mkOpt lib.types.str "" "specify block device. e.g. /dev/sda. device-by-id is valid too.";
    windowsPartSize =
      mkOpt lib.types.str "250G" "e.g.: '250G'. This part is imperative, because linux will take rest if default. Otherwise, you will have calculate and provision.";
    linuxPartSize =
      mkOpt lib.types.str "100%" "e.g.: '250G'. Default is best";
    efiPartSize =
      mkOpt lib.types.str "1G" "e.g.: '500M'. Default is best";
    swap = {
      enable = mkBoolOpt false "Enable manual swap partition";
      swapPartSize =
        mkOpt lib.types.str "" "e.g.: 16G.";
    };
    encryption = mkBoolOpt false "Enable encryption. Depends on sops configured key.";
  };
  config = mkIf cfg.enable {
    myVars.isEphemeral = true;
    profiles.${namespace}.my.nixos = {
      features.persistence = enabled;
    };

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
      {
        assertion = !(cfg.swap.enable && cfg.swap.swapPartSize == "");
        message = ''
          when swapPart.enable, you Must specify swaPart.size!
        '';
      }
    ];

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "${cfg.blockDevice}";
          content = {
            type = "gpt";
            # preCreateHook = ''              # Might not be necessary, for good measure
            #    echo "Wiping disk ${cfg.blockDevice}..."
            #    wipefs -a ${cfg.blockDevice}
            #    sgdisk -Z ${cfg.blockDevice}
            # '';
            partitions = {
              efi = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/esp";
                  mountOptions = ["umask=0077"];
                };
              };
              bpool = {
                size = "4G";
                content = {
                  type = "zfs";
                  pool = "bpool";
                };
              };
              rpool = {
                end = "-1M";
                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
              bios = {
                size = "1M";
                type = "EF02";
              };
            };
          };
        };
      };
      zpool = {
        bpool = {
          type = "zpool";
          options = {
            ashift = "12";
            autotrim = "on";
            compatibility = "grub2";
          };
          rootFsOptions = {
            acltype = "posixacl";
            canmount = "off";
            compression = "lz4";
            devices = "off";
            normalization = "formD";
            relatime = "on";
            xattr = "sa";
            "com.sun:auto-snapshot" = "false";
          };
          mountpoint = "/boot";
          datasets = {
            nixos = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "nixos/root" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/boot";
            };
          };
        };

        rpool = {
          type = "zpool";
          options = {
            ashift = "12";
            autotrim = "on";
          };
          rootFsOptions =
            (lib.optionalAttrs cfg.encryption {
              "com.sun:auto-snapshot" = "false";
              # encryption
              encryption = "aes-256-gcm"; # Add encryption algorithm
              keyformat = "passphrase"; # or "hex" or "raw" for key files
              keylocation = "prompt";
              # keylocation = "file://${config.sops.secrets.generic-pass.path}"; # IMPORTANT: Update this
            })
            // {
              acltype = "posixacl";
              canmount = "off";
              compression = "zstd";
              dnodesize = "auto";
              normalization = "formD";
              relatime = "on";
              xattr = "sa";
            };
          mountpoint = "/";

          datasets = {
            nixos = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "nixos/var" = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "nixos/empty" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/";
              postCreateHook = "zfs snapshot rpool/nixos/empty@start";
            };
            "nixos/home" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/home";
            };
            "nixos/var/log" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/var/log";
            };
            "nixos/var/lib" = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "nixos/config" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/etc/nixos";
            };
            "nixos/persistent" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/persistent";
            };
            "nixos/nix" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/nix";
            };
            docker = {
              type = "zfs_volume";
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/containers";
              };
            };
          };
        };
      };
    };
    boot.loader.efi.efiSysMountPoint = "/boot/esp";
    # NOTE: not sure why this is needed..
    boot.initrd.systemd.enable = true;

    boot.initrd.systemd = {
      services.initrd-rollback-root = {
        after = ["zfs-import-rpool.service"];
        wantedBy = ["initrd.target"];
        before = [
          "sysroot.mount"
        ];
        path = [pkgs.zfs];
        description = "Rollback root fs";
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = "zfs rollback -r rpool/nixos/empty@start && echo '  >> >> rollback complete << <<'";
      };
    };
    fileSystems."/" = {
      device = "rpool/nixos/empty";
      fsType = "zfs";
    };
    fileSystems."/nix" = {
      device = "rpool/nixos/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/etc/nixos" = {
      device = "rpool/nixos/config";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/boot" = {
      device = "bpool/nixos/root";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/persistent" = {
      device = "rpool/nixos/persistent";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/var/log" = {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
    };

    fileSystems."/var/lib/containers" = {
      device = "/dev/zvol/rpool/docker";
      fsType = "ext4";
    };
  };
}
