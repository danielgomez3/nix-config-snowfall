# xxmodulexx.nix
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
  cfg = config.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx = {
    enable = mkEnableOption "Enable custom 'xxplatformxx', module 'xxmodulexx', for namespace '${namespace}'.";
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
