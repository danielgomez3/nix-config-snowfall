{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.xxmodulenamexx;
  inherit (lib) mkEnableOption mkIf;
in {
  options.${namespace}.xxmoduletypexx.xxcategoryxx.xxoptionxx = {
    enable = mkEnableOption "Enable xxmodulenamexx";
  };
  config = mkIf cfg.enable {
    # NOTE: top-level nix-code here.
  };
}
