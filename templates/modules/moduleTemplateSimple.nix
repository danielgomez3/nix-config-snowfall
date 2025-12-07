{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.profiles.${namespace}.xxmodulenamexx;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.xxmodulenamexx = {
    enable = mkEnableOption "Enable xxmodulenamexx";
  };
  config = mkIf cfg.enable {
    # NOTE: top-level nix-code here.
  };
}
