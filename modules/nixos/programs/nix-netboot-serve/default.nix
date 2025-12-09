# nix-netboot-serve.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.nix-netboot-serve;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.nix-netboot-serve = {
    enable = mkEnableOption "Enable custom 'nixos', module 'nix-netboot-serve', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
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

    imports = [inputs.nix-netboot-serve.nixosModules.nix-netboot-serve];
    services.nix-netboot-serve = {
      enable = true;
      listen = "0.0.0.0:3030";
    };
  };
}
