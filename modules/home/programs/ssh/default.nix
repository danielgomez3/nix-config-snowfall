# ssh.nix
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
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.programs.ssh = {
    enable = mkEnableOption "Enable custom 'home', module 'ssh', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # userKnownHostsFile = "${self.outPath}/hosts/${osConfig.myVars.hostname}/known_hosts";
      enableDefaultConfig = false;
      #   matchBlocks = {
      #     "server-hosts" = {
      #       host = "github.com gitlab.com";
      #       identitiesOnly = true;
      #     };
      #     "server" = {
      #       # hostname = "server.danielgomezcoder.org";
      #       hostname = "server";
      #       user = "danielgomez3"; # FIXME: use sops nix
      #     };
      #     "hetzner-vps" = {
      #       # hostname = "server.danielgomezcoder.org";
      #       hostname = "danielgomezcoder.org";
      #       user = "root"; # FIXME: use sops nix
      #     };
      #     "desktop" = {
      #       hostname = "desktop";
      #       user = "daniel"; # FIXME: use sops nix
      #     };
      #     "laptop" = {
      #       hostname = "laptop";
      #       user = "daniel"; # FIXME: use sops nix
      #     };
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
