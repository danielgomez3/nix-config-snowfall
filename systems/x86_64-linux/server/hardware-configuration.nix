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
