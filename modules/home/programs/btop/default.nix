# modules/home/programs/btop/default.nix
# TODO: fix the conditional logic with just a string instead with default value of pkgs.btop something
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
  osConfig,
  ...
}: let
  cfg = config.profiles.${namespace}.my.home.programs.btop;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;

  btopPackage =
    if osConfig.myVars.isAMD
    then pkgs.btop-rocm
    else if osConfig.myVars.isNVIDIA
    then pkgs.btop-cuda
    else pkgs.btop; # else if osConfig.myVars.btop
in {
  options.profiles.${namespace}.my.home.programs.btop = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'btop', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      package = btopPackage;
      settings = {
        show_gpu = true;
        gpu_support = true;
      };
    };
  };
}
