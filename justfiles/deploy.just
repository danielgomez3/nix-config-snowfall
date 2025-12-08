
#
#
# Global vars
# 
# 

currentHost := "`hostname`"




# 
#
# Deployment
# 
# 

deploy-rs target=(currentHost): pre-command-hooks
      nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#{{target}}"

# Deploy all NixOS configurations
# TODO: this is too much. Snowflake probably already iterate
# TODO: Look into systemd services for each, and more uniform logging
deploy-rs-all: pre-command-hooks
    #!/usr/bin/env bash
    # TODO: add usb device(s)
    # TODO: make into one-off systemd unit?
    : > /var/tmp/just-apply_all.log
    for i in server desktop laptop living-room test-machine nas-server llm-machine hetzner-vps 3D-printer; do
        nohup nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#$i" \
        | tee -a /var/tmp/just-apply_all.log \
        | tee "/var/tmp/just-apply_$i.log" >/dev/null &
    done 
    
# Deploy NixOS on a connected usb
deploy-usb flake block_device:
    -sudo wipefs -a {{block_device}}
    sudo nix run 'github:nix-community/disko/latest#disko-install' -- --extra-files ~/.config/sops/age/keys.txt /root/.config/sops/age/keys.txt --flake '.#{{flake}}' --disk main {{block_device}}

# Deploy NixOS on remote disk. Assumes you have a NixOS usb mounted on a device to 'infect' a hard drive (disk) on that computer.
deploy-usb-remote-disk flake network_target block_device:
    ssh root@{{network_target}} nix run 'github:nix-community/disko/latest#disko-install' -- --extra-files /root/.config/sops/age/keys.txt /run/secrets/luks_password --flake 'github:danielgomez3/nix-config/new-main#{{flake}}' --write-efi-boot-entries --disk main {{block_device}}


