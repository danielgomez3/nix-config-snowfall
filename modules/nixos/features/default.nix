{
  lib,
  pkgs,
  namespace,
  ...
}: {
  imports = [
    ./systemd-boot.nix
  ];
}
