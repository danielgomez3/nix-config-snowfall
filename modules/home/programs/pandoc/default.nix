# pandoc.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.pandoc;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.programs.pandoc = {
    enable = mkEnableOption "Enable custom 'home', module 'pandoc', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {

  programs.pandoc = {
    enable = true;
    defaults = {
      toc = true;
      from = "markdown+hard_line_breaks";
    };
    # templates = {
    #   "default.latex" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    #   "default.markdown" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    #   "default.pdf" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    # };
  };
    # profiles.${namespace}.my.home = {
    #   bundles = {
    #   };
    #   features = {
    #   };
    #   programs = {
    #   };
    # };
    # profiles.${namespace}.my.nixos = {
    #   bundles = {
    #   };
    #   features = {
    #   };
    #   programs = {
    #   };
    # };
  };
}
