{
  lib,
  pkgs,
  namespace,
  ...
}: let
in {
  imports = lib.${namespace}.autoImportNamedFiles ./.;
}
