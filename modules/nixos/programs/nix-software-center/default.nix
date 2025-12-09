# nix-software-center.nix
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
}: let
  cfg = config.profiles.${namespace}.my.nixos.programs.nix-software-center;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.nix-software-center = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'nix-software-center', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    environment.systemPackages = [
      inputs.nix-software-center.packages.${system}.nix-software-center
    ];
  };
}
