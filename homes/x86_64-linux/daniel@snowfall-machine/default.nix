# homes/x86_64-linux/daniel@snowfall-machine/default.nix
{
  lib,
  namespace,
  ...
}:
with lib; # ← Just use lib, not lib.${namespace}

  {
    # Remove the with lib.${namespace} line
    # We'll access namespace directly

    # Basic home configuration
    home.username = "daniel";
    home.homeDirectory = "/home/daniel";
    home.stateVersion = "24.11";

    # Direct configuration without namespace helper
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        colorscheme catppuccin
      '';
    };
  }
