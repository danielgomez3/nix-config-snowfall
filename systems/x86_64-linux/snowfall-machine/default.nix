# systems/x86_64-linux/test/default.nix
{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./hardware.nix];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/virtio-os";
  boot.loader.grub.useOSProber = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  users.users.philip = {
    isNormalUser = true;
    description = "Philip";
    extraGroups = ["networkmanager" "wheel"];
  };

  services.openssh.enable = true;

  nix.settings.trusted-users = ["root" "@wheel"];
  security.sudo.extraRules = [
    {
      users = ["philip"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD" "SETENV"];
        }
      ];
    }
  ];

  system.stateVersion = "24.11";

  # EXTRA:
  ${namespace} = {
    programs.plex.enable = true;
  };
}
