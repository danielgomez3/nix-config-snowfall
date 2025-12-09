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


list:
    just --list

# 
# 
# Building, evaluation, diagnostic
# 
# 


[default]
show:
    git add -A :/
    nix flake show --all-systems

build-configuration host: pre-command-hooks
    nix build .#nixosConfigurations.test.config.system.build.toplevel

eval-configuration host: pre-command-hooks
    nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel.drvPath

# observe built closure for a package, etc. Requires build-configuration
query-configuration package:
    nix-store --query --requisites ./result | grep {{package}}

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
create-system platform host username:
    mkdir -p ./systems/{{platform}}/{{host}}/
    cp ./extra/my-nix-mold-files/host/default.nix ./systems/{{platform}}/default.nix
    sed -i -E 's/\bxxhostxx\b/{{host}}/g' ./systems/{{platform}}/default.nix
    sed -i -E 's/\bxxusernamexx\b/{{username}}/g' ./systems/{{platform}}/default.nix
    sed -i -E 's/\bxxplatformxx\b/{{platform}}/g' ./systems/{{platform}}/default.nix



# Module created under /modules/nixos/{{category}}. Create category first!
create-module platform category module: 
    mkdir -p ./modules/{{platform}}/{{category}}/{{module}}/
    cp ./extra/my-nix-mold-files/module/default.nix ./modules/{{platform}}/{{category}}/{{module}}/default.nix
    t="{{module}}/default.nix" && sed -i "/];/i ./$t" "./modules/{{platform}}/{{category}}/{{module}}/default.nix"
    sed -i -E 's/\bxxcategoryxx\b/{{category}}/g' ./modules/{{platform}}/{{category}}/{{module}}/default.nix
    sed -i -E 's/\bxxmodulexx\b/{{module}}/g' ./modules/{{platform}}/{{category}}/{{module}}/default.nix
    sed -i -E 's/\bxxplatformxx\b/{{platform}}/g' ./modules/{{platform}}/{{category}}/{{module}}/default.nix

[confirm("Are you sure you want to nuke this directory?")]
delete-category platform category:
    rm -rf ./modules/{{platform}}/{{category}}


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


repl:
    # nix repl --file repl.nix --extra-experimental-features pipe-operators
    nix repl --extra-experimental-features pipe-operators


[confirm("You are about to nuke everything dude..")]
_migrate:
    #!usr/bin/env bash

    # First migrate files to default.nix files
    find modules -type f -name "*.nix" | while read -r file; do
      dir="${file%.nix}" # strip .nix → modules/.../btop
      mkdir -p "$dir"    # create modules/.../btop
      mv "$file" "$dir/default.nix"
    done

    # Now, wrap them in conditional configuration

# 
#
# Testing
# 
# 

check:
    nix flake check --all-systems
    
check-system system:
    nix flake check --system {{system}}

# 
#
# virtualisation
# 
# 

# Run any config in a headless vm.
# TODO: Doesn't work, needs to copy age keys into build closure
run-configuration-in-vm-headless host: pre-command-hooks
    nixos-rebuild build-vm --flake .#{{host}}
    QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-{{host}}-vm -nographic 
    # QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-{{host}}-vm -nographic; reset 
    
run-configuration-in-vm-gui host: pre-command-hooks
    nixos-rebuild build-vm --flake .#{{host}}
    ./result/bin/run-{{host}}-vm -vnc :1 & \
    nix run nixpkgs#novnc -- --vnc localhost:5901 

    

run-isoConfigurations host:
    nix build .#install-isoConfigurations.{{host}}
    nix run nixpkgs#qemu -- -cdrom result/iso/*.iso -m 4096 -enable-kvm -vnc :1 & \
    nix run nixpkgs#novnc -- --vnc localhost:5901 


# 
#
# _
# 
# 

