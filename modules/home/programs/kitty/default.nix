# kitty.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.kitty;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.kitty = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'kitty', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };

    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
      };
    };
  };
}
