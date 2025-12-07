{
  lib,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  options.${namespace}.home.programs.neovim = {
    enable = mkEnableOption "Neovim configuration";

    theme = mkOption {
      type = types.str;
      default = "catppuccin";
      description = "Neovim theme";
    };
  };

  config = mkIf config.${namespace}.home.programs.neovim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        colorscheme ${config.${namespace}.home.programs.neovim.theme}
      '';
    };
  };
}
