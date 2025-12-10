# modules/home/programs/zsh/default.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.zsh;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.zsh = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'zsh', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        ignorePatterns = ["rm *" "pkill *" "cp *"];
        ignoreAllDups = true;
      };
      shellAliases = {
        # f = "fg";
        # j = "jobs";
        l = "ls -l";
        la = "ls -a";
        lt = "";
        # grep = "grep --color=always -IrnE --exclude-dir='.*'";
        # less = "less -FR";
        conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
        notes = "cd ~/Documents/notes/files && hx .";
        zrf = "zellij run floating";
        jambi = "jambi -c $HOME/.config/jambi/config.toml record --live";
        # send_desktop_downloads_to_server = "${pkgs.rsync}/bin/rsync --remove-source-files -avz desktop:~/Downloads/* server:~/Downloads/";
        # send_desktop_downloads_to_server_cwd = "${pkgs.rsync}/bin/rsync --remove-source-files -avz desktop:~/Downloads/* server:~/Downloads/";
      };
      # sessionVariables = {
      # };
      initContent = ''
        d=$HOME/Downloads
        WORDCHARS='*?[]~=&;!$%^(){}<>"'
        run(){ hap run --check "$@" > /dev/null & }

        # edit-command-line, emacs keybinds
        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey "^X^E" edit-command-line

      '';
      zplug = {
        enable = true;
        plugins = [
          {name = "hlissner/zsh-autopair";}
          # {name = "popstas/zsh-command-time";}
          # {name = "chriskempson/base16-shell";}
        ];
      };
    };
  };
}
