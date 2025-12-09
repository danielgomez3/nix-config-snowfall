# wezterm.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.wezterm;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.wezterm = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'wezterm', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    programs.wezterm = {
      enable = true;
      # package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = ''
        return {

          window_decorations = "NONE",
          audible_bell = "Disabled",
          hide_tab_bar_if_only_one_tab = true,
          warn_about_missing_glyphs = false,  -- Disables missing glyph warnings
          font = wezterm.font_with_fallback({'FiraCode Nerd Font Mono','Droid Sans Fallback'}),
          -- font = wezterm.font_with_fallback({'Symbols Nerd Font', 'Droid Sans Fallback'}),

          keys = {
            -- Disable Alt+Enter (fullscreen toggle)
            { key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },

          },

        }
      '';
    };
  };
}
