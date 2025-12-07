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
    ./flake-development/development.nix
    ./flake-development/deploy.nix
    # Add more shell files here
  ];
}
