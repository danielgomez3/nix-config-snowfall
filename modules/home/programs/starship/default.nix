# modules/home/programs/starship/default.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.starship;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.starship = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'starship', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        format = "$time\n$all";
        # right_format = lib.concatStrings [
        #   "$time"
        # ];
        time = {
          disabled = false;
          format = "🕒 [$time]($style)";
          use_12hr = true;
          # time_format = "%H:%M:%S";
          style = "bold dimmed white";
        };
        cmd_duration = {
          format = "took [$duration](bold yellow)";
          disabled = false;
          min_time = 0;
          show_milliseconds = false;
          # style = accent_style;
        };
      };
    };
  };
}
