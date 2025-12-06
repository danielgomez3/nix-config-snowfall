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
    ./flake-development/dev.nix
    # Add more shell files here
  ];
}
