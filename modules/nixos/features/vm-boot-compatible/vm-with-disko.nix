# NOTE: https://github.com/nix-community/disko/blob/7194cfe5b7a3660726b0fe7296070eaef601cae9/docs/interactive-vm.md?plain=1#L4
#
# For running VM on macos: https://www.tweag.io/blog/2023-02-09-nixos-vm-on-macos/
# virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
{lib, ...}: {
  virtualisation.vmVariantWithDisko = {
    virtualisation.graphics = false;
    virtualisation.fileSystems."/persistent".neededForBoot = true;
    # For running VM on macos: https://www.tweag.io/blog/2023-02-09-nixos-vm-on-macos/
    # virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    disko.devices.disk.main.imageSize = "20G";
  };
}
