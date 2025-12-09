_: {
  # Enable Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Disable wpa_supplicant
  networking.wireless.enable = false;
  # Enable NetworkManager
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
