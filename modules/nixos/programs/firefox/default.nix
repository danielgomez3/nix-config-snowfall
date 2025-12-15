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

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;

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
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'firefox', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # assertions = [
    #   {
    #     assertion = config.profiles.${namespace}.my.home.firefox;
    #     message = "enable either hm or nixos module, not both";
    #   }
    # ];
    programs.firefox = {
      enable = true;
      preferences =
        if config.myVars.isHardwareLimited or false
        then limitedHardwarePrefs
        else basePreferences;
    };
  };
}
