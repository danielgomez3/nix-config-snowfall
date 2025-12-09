# raw-image-config.nix
# NOTE: this is needed if you want to generate a .raw image?
{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: {
  boot.loader.grub.efiSupport = lib.mkDefault true;
  boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;

  fileSystems."/".device = "/dev/null";
  boot.loader.grub.devices = ["/dev/null"];
}
