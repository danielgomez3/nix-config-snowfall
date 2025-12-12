# modules/nixos/features/secure-boot/default.nix
# TODO: make 'secure-boot.nix' via relative import. This makes the default.nix a sort of 'interface'.
{
  lib,
  pkgs,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  config,
  ...
}: {imports = [./lanzaboote.nix];}
