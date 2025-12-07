# systems/x86_64-linux/test/default.nix
{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
}
