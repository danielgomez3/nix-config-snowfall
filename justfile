# #
# justfile
# author: danielgomezcoder@gmail.com
# #


#
#
# Global vars
# 
# 

# mod main
default := "default"
currentHost := "`hostname`"
none := ""


# 
# 
# Building, evaluation, diagnostic
# 
# 

[default]
list:
    just --list

build-configuration host: pre-command-hooks
    nix build .#nixosConfigurations.test.config.system.build.toplevel

eval-configuration host: pre-command-hooks
    nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel.drvPath


# 
#
# Development
# 
# 

development-shell shell=(default):
    nix develop .#{{shell}}
    
metadata input=(none):
    nix flake metadata {{input}}

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




# 
#
# Virtualization
# 
# 

# 

# utility functions
# 
# 

push:
    git add -A :/
    git commit
    git push

commit:
    git add -A :/
    git commit



# TODO
create-system:
    echo "hello"

# Category created under /modules/nixos
[private]
create-category platform category:
    mkdir -p ./modules/{{platform}}/{{category}}
    cp ./templates/extra/category/default.nix ./modules/{{platform}}/{{category}}/

# Module created under /modules/nixos/{{category}}. Create category first!
create-module platform category module: 
    cp ./templates/extra/module/default.nix ./modules/{{platform}}/{{category}}/{{module}}.nix
    t="{{module}}.nix" && sed -i "/];/i ./$t" "./modules/{{platform}}/{{category}}/default.nix"
    sed -i -E 's/\bxxcategoryxx\b/{{category}}/g' ./modules/{{platform}}/{{category}}/{{module}}.nix
    sed -i -E 's/\bxxmodulexx\b/{{module}}/g' ./modules/{{platform}}/{{category}}/{{module}}.nix
    sed -i -E 's/\bxxplatformxx\b/{{platform}}/g' ./modules/{{platform}}/{{category}}/{{module}}.nix

[confirm("Are you sure you want to delete this directory?")]
delete-module module:
    rm -rf ./modules/{{module}}


# 
#
# private functions (for internal justfile use)
# 
# 


[private]
pre-command-hooks:
    nix flake update mysecrets
    git add -A :/

# TODO: WIP, doesn't work
[private]
ssh-keygen username ip_address:
    # Generate SSH key (only if doesn't exist)
    ssh {{username}}@{{ip_address}} "test -f /home/{{username}}/.ssh/id_ed25519 || ssh-keygen -t ed25519 -b 4096 -C '{{ip_address}} key, danielgomezcoder@gmail.com' -f /home/{{username}}/.ssh/id_ed25519 -N ''"
    # Copy the public key to local authorized_keys (avoid duplicates)
    ssh {{username}}@{{ip_address}} "cat /home/daniel/.ssh/id_ed25519.pub" >> ~/.ssh/authorized_keys




# 
#
# _
# 
# 



