# mangohud.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.mangohud;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.mangohud = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'mangohud', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
      settingsPerApplication = {
        mpv = {
          no_display = true;
        };
      };
      settings = {
        output_folder = "~/.config/mangologs";
        # CPU
        cpu_stats = 1;
        cpu_temp = 1;
        # cpu_power = true;

        # GPU
        gpu_stats = 1;
        gpu_temp = 1;
        vram = true;
        # gpu_core_clock = true;

        # SYSTEM
        ram = 1;
        frametime = 0;
        show_fps_limit = 1;
        fps = true;

        # no_display = true; # Hide hud by default (Show by holding right-shift then press F12)
      };
    };
  };
}
