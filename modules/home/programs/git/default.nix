# modules/home/programs/git/default.nix
# NOTE
# create gpg key:
# gpg --pinentry-mode loopback --passphrase '' --quick-generate-key "josh doe email"
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
  cfg = config.profiles.${namespace}.my.home.programs.git;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.git = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'git', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # services.gpg-agent = {
    #   enable = true;
    #   defaultCacheTtl = 1800; # Cache passphrase for 30 minutes
    #   # enableSshSupport = true;
    #   # pinentryFlavor = "gnome3"; # Use "qt", "curses", etc., based on your DE
    # };

    programs.gpg.enable = true;

    programs.delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
    programs.git = {
      enable = true;
      settings = {
        user.name = "danielgomez3";
        user.email = "danielgomezcoder@gmail.com";
        # my mail server
        sendemail."user1@danielgomezcoder.org" = {
          smtpuser = "user1@danielgomezcoder.org";
          smtpserver = "mail.danielgomezcoder.org";
          smtpserverport = 465;
          smtpencryption = "ssl";
        };
      };
      # user = {
      #   name = "danielgomez3";
      #   email = "danielgomezcoder@gmail.com";
      # };
      # settings = {
      #   extraConfig = {
      #     commit.gpgsign = true;
      #     gpg.format = "ssh";
      #     user.signingkey = "~/.ssh/id_ed25519.pub";
      #     push.autoSetupRemote = true;
      #   };
      # };
      signing = {
        # gpg --list-secret-keys --keyid-format=long
        key = "D0FB99C8D0AECA2E"; # FIXME: put in sops, or put private key somewhere??
        signByDefault = true;
      };
    };
  };
}
