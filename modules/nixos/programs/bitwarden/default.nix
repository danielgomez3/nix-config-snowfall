{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.nixos.programs.bitwarden;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.${namespace}.nixos.programs.bitwarden = {
    enable = mkEnableOption "Bitwarden password manager";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (rbw.override {withFzf = true;})
      pinentry-curses
    ];
  };
}
