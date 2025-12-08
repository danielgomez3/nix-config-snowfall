{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.xxmoduletypexx.xxcategoryxx.xxoptionxx;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.xxmoduletypexx.xxcategoryxx.xxoptionxx = {
    enable = mkEnableOption "Enable xxmodulenamexx";
  };
  config = mkIf cfg.enable {
    # NOTE: top-level nix-code here.
  };
}
