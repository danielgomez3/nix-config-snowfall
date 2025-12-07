{lib, ...}: {
  options.myconfig.feature.enable = lib.mkEnableOption "Feature";
  config = lib.mkIf config.myconfig.feature.enable {
    # Configuration
  };
}
