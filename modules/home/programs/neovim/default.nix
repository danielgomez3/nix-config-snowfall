{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
with lib; {
  options.${namespace}.programs.neovim.enable = mkEnableOption "Neovim";

  config = mkIf config.${namespace}.programs.neovim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
