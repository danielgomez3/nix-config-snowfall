# thunderbird.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.thunderbird;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.thunderbird = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'thunderbird', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };

    home.packages = [pkgs.thunderbird];
    programs.thunderbird = {
      enable = false;
      #   profiles.default = {
      #     isDefault = true;
      #   };
      # };

      # # Configure your email account
      # accounts.email.accounts = {
      #   "user1@danielgomezcoder.org" = {
      #     address = "user1@danielgomezcoder.org";
      #     realName = "Your Name";
      #     passwordCommand = "echo 'poopy'";
      #     primary = true;

      #     # IMAP (receiving emails)
      #     imap = {
      #       host = "mail.danielgomezcoder.org";
      #       port = 993;
      #       tls.enable = true;
      #     };

      #     # SMTP (sending emails)
      #     smtp = {
      #       host = "mail.danielgomezcoder.org";
      #       port = 465;
      #       tls.enable = true;
      #     };

      #     # Enable in Thunderbird
      #     thunderbird.enable = true;
      #   };
    };
  };
}
