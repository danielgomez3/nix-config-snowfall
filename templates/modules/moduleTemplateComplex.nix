# /modules/xxsubmodulexx/xxmodulenamexx.nix
{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; # Your namespace

  let
    cfg = config.${namespace}.xxsubmodulexx.xxmodulenamexx;
  in {
    config = mkIf cfg.enable {
      # Nix code here
    };
  }
