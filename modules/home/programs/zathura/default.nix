# zathura.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.zathura;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.zathura = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'zathura', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        scroll-step = 50;
      };
      # extraConfig =
      # ''
      #     # Clipboard
      #     set selection-clipboard clipboard
      #     set scroll-step 50
      # '';
    };
  };
}
