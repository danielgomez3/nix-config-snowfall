{
  lib,
  pkgs,
  namespace,
  ...
}: {
  imports = lib.${namespace}.autoImportNamedFiles ./.;
}
