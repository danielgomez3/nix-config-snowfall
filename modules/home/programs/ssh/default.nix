# modules/home/programs/ssh/default.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.ssh;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.ssh = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'ssh', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # userKnownHostsFile = "${self.outPath}/hosts/${osConfig.myVars.hostname}/known_hosts";
      enableDefaultConfig = false;
    };
  };
}
