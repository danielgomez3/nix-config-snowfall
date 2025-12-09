# xxmodulexx.nix
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
  cfg = config.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;
  inherit (lib) mkEnableOption mkIf;

  modpack = pkgs.fetchPackwizModpack {
    url = "http://danielgomezcoder.org/pack.toml";
    packHash = "sha256-sHw1MAGg+m0654LvATknwDkZHE4h1GrGK8ZNzhsXwVc="; # Replace with actual hash after first build
  };
in {
  options.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx = {
    enable = mkEnableOption "Enable custom 'xxplatformxx', module 'xxmodulexx', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my = {
    #   nixos = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    #   home = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    # };

    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    services.minecraft-servers = {
      enable = false;
      eula = true;
      openFirewall = true;
      servers.fabric = {
        enable = true;

        # Use the versions from your modpack
        package = pkgs.fabricServers.fabric-1_20_1.override {
          loaderVersion = "0.17.3";
        };

        # symlinks = collectFilesAt modpack "mods";
        # files = collectFilesAt modpack "config";
      };
    };
  };
}
