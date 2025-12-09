# firefox.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.firefox;
  inherit (lib) mkEnableOption mkIf;

  basePreferences = {
    "accessibility.typeaheadfind.enablesound" = false; # Disable bell in ctrl-f
    # Other universal preferences...
    "sidebar.verticalTabs" = true; # FIXME this isn't working?
  };

  limitedHardwarePrefs =
    basePreferences
    // {
      "layout.css.devPixelsPerPx" = "0.9";
    };
in {
  options.profiles.${namespace}.my.nixos.programs.firefox = {
    enable = mkEnableOption "Enable custom 'nixos', module 'firefox', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
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
    programs.firefox = {
      enable = true;
      preferences =
        if config.myVars.isHardwareLimited or false
        then limitedHardwarePrefs
        else basePreferences;
    };
  };
}
