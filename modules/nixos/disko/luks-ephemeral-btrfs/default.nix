# modules/nixos/disko/luks-ephemeral-btrfs/disko-config.nix
# TODO
# - Remove all the excess persistent directories tha you THINK are helping you log in with sops. I think the only like I needed was:
# age.keyFile =
#     if config.myVars.isEphemeral
#     then "/persistent/root/.config/sops/age/keys.txt" # Ephemeral: use persistent location
#     else "/root/.config/sops/age/keys.txt"; # Non-ephemeral: normal location
# To enabled persistence and log in across boots.
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
  cfg = config.profiles.${namespace}.my.nixos.disko.luks-ephemeral-btrfs;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.disko.luks-ephemeral-btrfs = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'disko', of module 'luks-ephemeral-btrfs', for namespace '${namespace}'.";
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
    profiles.${namespace}.my.nixos = {
      features = {
        persistence = enabled;
      };
    };
    myVars.isEphemeral = true;

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
        assertion = !(cfg.swapPart.enable && cfg.swapPart.size == "");
        message = ''
          when swapPart.enable, you Must specify swaPart.size!
        '';
      }
    ];

    fileSystems."/persistent".neededForBoot = true;

    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=4G" # TODO: what is this?
          "defaults"
          # set mode to 755, otherwise systemd will set it to 777, which cause problems.
          # relatime: Update inode access times relative to modify or change time.
          "mode=755"
        ];
      };

      disk.main = {
        type = "disk";
        # When using disko-install, we will overwrite this value from the commandline
        device = "${cfg.blockDevice}"; # The device to partition
        content = {
          type = "gpt";
          partitions = {
            # The EFI & Boot partition
            ESP = {
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
            # The root partition
            luks = {
              size = "${cfg.linuxPartSize}";
              content = {
                type = "luks";
                name = "encrypted";
                # settings = {
                # };
                # Whether to add a boot.initrd.luks.devices entry for the specified disk.
                initrdUnlock = true;

                # encrypt the root partition with luks2 and argon2id, will prompt for a passphrase, which will be used to unlock the partition.
                # cryptsetup luksFormat
                extraFormatArgs = [
                  "--type luks2"
                  "--cipher aes-xts-plain64"
                  "--hash sha512"
                  "--iter-time 5000"
                  "--key-size 256"
                  "--pbkdf argon2id"
                  # use true random data from /dev/random, will block until enough entropy is available
                  "--use-random"
                ];
                extraOpenArgs = [
                  "--timeout 10"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"]; # Force override existing partition
                  subvolumes =
                    (lib.optionalAttrs cfg.swapPart.enable {
                      "@swap" = {
                        mountpoint = "/swap";
                        swap.swapfile.size = "${cfg.swapPart.size}";
                      };
                    })
                    // {
                      # mount the top-level subvolume at /btr_pool
                      # it will be used by btrbk to create snapshots
                      "/" = {
                        mountpoint = "/btr_pool";
                        # btrfs's top-level subvolume, internally has an id 5
                        # we can access all other subvolumes from this subvolume.
                        mountOptions = ["subvolid=5"];
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress-force=zstd:1"
                          "noatime"
                        ];
                      };
                      "@persistent" = {
                        mountpoint = "/persistent";
                        mountOptions = [
                          "compress-force=zstd:1"
                          "noatime"
                        ];
                      };
                      "@tmp" = {
                        mountpoint = "/tmp";
                        mountOptions = [
                          "compress-force=zstd:1"
                          "noatime"
                        ];
                      };
                      "@snapshots" = {
                        mountpoint = "/snapshots";
                        mountOptions = [
                          "compress-force=zstd:1"
                          "noatime"
                        ];
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
}
