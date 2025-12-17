# modules/nixos/features/nix-netboot-serve/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.nix-netboot-serve;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.nix-netboot-serve = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'nix-netboot-serve', for namespace '${namespace}'.";
  };
  imports = [inputs.nix-netboot-serve.nixosModules.nix-netboot-serve];
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];
    services.nix-netboot-serve = {
      enable = true;
      listen = "0.0.0.0:3030";
    };
  };
}
