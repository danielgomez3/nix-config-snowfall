# shells/default.nix
{
  inputs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [
    ./dev.nix
    # Add more shell files here
  ];
}
