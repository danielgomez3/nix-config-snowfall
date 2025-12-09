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
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.nix-software-center = {
    enable = mkEnableOption "Enable custom 'nixos', module 'nix-software-center', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {

  environment.systemPackages = [
    inputs.nix-software-center.packages.${config.nixpkgs.hostPlatform.system}.nix-software-center
  ];
    # profiles.${namespace}.my = {
    #   nixos = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    #   home = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    # };
  };
}
