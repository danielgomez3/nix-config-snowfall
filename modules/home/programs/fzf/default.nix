# modules/home/programs/fzf/default.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.fzf;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.fzf = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'fzf', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.home = {
    # };
    programs.fzf = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      # Fzf widgets
      defaultCommand = "${lib.getExe pkgs.fd} --strip-cwd-prefix=always --exclude .git";
      changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type d --follow --exclude .git --strip-cwd-prefix=always --base-directory .";
      # fileWidgetCommand = "${lib.getExe pkgs.fd} --type f --follow --exclude .git --strip-cwd-prefix=always --base-directory ../";
      fileWidgetCommand = "${lib.getExe pkgs.fd} --type f --follow --exclude .git --strip-cwd-prefix=always --base-directory .";
    };
  };
}
