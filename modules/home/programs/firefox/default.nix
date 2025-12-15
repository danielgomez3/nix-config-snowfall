# modules/home/programs/firefox/default.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.firefox;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.firefox = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'firefox', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.home = {
    # };
    programs.firefox = {
      enable = true;
      # NOTE For any theming to be applied, you need to tell this module which profiles you're using:
      profiles = {
        daniel = {
          # bookmarks, extensions, search engines...
        };
      };
    };
  };
}
