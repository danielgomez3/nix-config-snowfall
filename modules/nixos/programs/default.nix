{
  lib,
  pkgs,
  config,
  inputs,
  namespace,
  ...
}: let
in {
  imports = [
    ./bitwarden.nix
  ];
}
