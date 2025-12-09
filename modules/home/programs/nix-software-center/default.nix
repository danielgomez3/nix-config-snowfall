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
  cfg = config.profiles.${namespace}.my.home.programs.nix-software-center;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.nix-software-center = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'nix-software-center', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    environment.systemPackages = [
      inputs.nix-software-center.packages.${config.nixpkgs.hostPlatform.system}.nix-software-center
    ];
  };
}
