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
delim := "__"
tdir := "./extra/my-nix-mold-files" # template dir


list:
    just --list

# 
# 
# Building, evaluation, diagnostic
# 
# 

[confirm("Hey, you're about to nuke a file or dir! (y/n)")]
nuke:
    echo "continuing.."
    

[default]
show:
    git add -A :/
    nix flake show --all-systems

build-configuration host: pre-command-hooks
    nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel

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

apply target: pre-command-hooks
    #!/usr/bin/env bash
    input="{{target}}"
    IFS=',' read -r -a devices <<< "$input"
    for i in "${devices[@]}"; do
      nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#$i"
    done


[confirm("You are about to completely wipe a device! Continue? (Y/N)")]
deploy host ip_address:
    root_dir=$(mktemp -d) && \
    trap 'rm -rf "$root_dir"' EXIT && \
    mkdir -p "${root_dir}/root/.config/sops/age" && \
    cp ~/.config/sops/age/keys.txt "${root_dir}/root/.config/sops/age/keys.txt" && \
    nix run github:nix-community/nixos-anywhere/main -- --extra-files "$root_dir" --copy-host-keys --flake .#{{host}} --target-host root@{{ip_address}}


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
    root_dir=$(mktemp -d) && \
    trap 'rm -rf "$root_dir"' EXIT && \
    mkdir -p "${root_dir}/root/.config/sops/age" && \
    cp ~/.config/sops/age/keys.txt "${root_dir}/root/.config/sops/age/keys.txt" && \
    sudo nix run 'github:nix-community/disko/latest#disko-install' -- --extra-files ${root_dir} /persistent/root/ --flake '.#{{flake}}' --disk main {{block_device}}

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


sed search replace file:
    sed -i -E 's|\b__{{search}}__\b|{{replace}}|g' {{file}}

# Provide full path of block device
create-system platform host username block_device: nuke
    #!/usr/bin/env bash
    echo "creating nixos system..."
    path="./systems/{{platform}}/{{host}}"
    file="$path/default.nix"
    mkdir -p $path
    cp {{tdir}}/system/default.nix $file
    just sed host {{host}} $file
    just sed username {{username}} $file
    just sed block_device {{block_device}} $file
    just sed platform {{platform}} $file
    echo "creating its 'homes' module..."
    path="./homes/{{platform}}/{{username}}@{{host}}"
    file="$path/default.nix"
    mkdir -p $path
    cp {{tdir}}/homes/default.nix $file
    just sed platform {{platform}} $file
    just sed username {{username}} $file
    just sed block_device {{block_device}} $file

# Module created under /modules/nixos/{{category}}. Create category first!
create-module platform category module: nuke
    #!/usr/bin/env bash
    echo "creating module..."   
    path="./modules/{{platform}}/{{category}}/{{module}}"
    file="$path/default.nix"
    mkdir -p $path
    cp {{tdir}}/module/{{platform}}/default.nix $file
    just sed category {{category}} $file
    just sed module {{module}} $file
    just sed platform {{platform}} $file

create-disko module: nuke
    #!/usr/bin/env bash
    echo "creating disko module..."
    path="./modules/nixos/disko/{{module}}"
    file="$path/default.nix"
    mkdir -p $path
    cp {{tdir}}/disko/default.nix $file
    just sed module {{module}} $file
    

create-overlay overlay: nuke
    #!/usr/bin/env bash
    echo "creating overlay..."
    path="./overlays/{{overlay}}"
    file="$path/default.nix"
    mkdir -p $path
    cp {{tdir}}/overlays/default.nix $file
    just sed "overlay" {{overlay}} $file

create-package package: nuke
    mkdir -p ./packages/{{package}}/
    cp {{tdir}}/packages/default.nix ./packages/{{package}}/default.nix

delete-category platform category: nuke
    rm -rf ./modules/{{platform}}/{{category}}

# Takes the full module/file-path name, renames the file, fixes the module path in the file, and does so across all files that depend on it!
# Caveats:
# - Does not change category or platform, you're better off creating a new file.
# rename-module platform category old-module-name new-module-name:
#     #/usr/bin/env bash
#     path="./{{platform}}/{{category}}/{{old-module-name}}"
#     file="$path/default.nix"
#     newfile="./{{platform}}/{{category}}/{{new-module-name}}/default.nix"
#     just sed {{module-path}} {{rename}} 
#     # fixes the module path as dep.
#     find ./modules -type f -exec sed -i 's|{{module-path}}|{{new-module-name}}|g' {} +

# 
#
# private functions (for internal justfile use)
# 
# 


[private]
pre-command-hooks:
    # nix flake update mysecrets
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

# NOTE: example:
# nix eval .#nixosConfigurations.laptop.config.services.openssh.enable
check-if-enabled host module-path:
    nix eval .#nixosConfigurations.{{host}}.config.{{module-path}}.enable

# NOTE don't understand this
# example:
# nix eval .#nixosConfigurations.laptop.config.myVars
check-values-json option:
    nix eval .#nixosConfigurations.laptop.config.{{option}} --apply 'cfg: builtins.attrNames cfg' --json
# 
#
# virtualisation
# 
# 

# Run any config in a headless vm, here in your window.
# TODO: Doesn't work, needs to copy age keys into build closure
run-configuration-in-vm-headless host: pre-command-hooks
    nixos-rebuild build-vm --flake .#{{host}}
    QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-{{host}}-vm -nographic 
    # QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-{{host}}-vm -nographic; reset 
    

# Run any config in a headless vm as a background web service to view via noVNC.
# 8GB RAM, 8 CPU cores, hardware virtualization, fast virtio gpu.
run-configuration-in-vm-gui host: pre-command-hooks
    # -rm ./*.qcow2
    nixos-rebuild build-vm --flake .#{{host}}
    # ./result/bin/run-{{host}}-vm -vnc :1 \
    # -m 8192 -smp 8 -enable-kvm -cpu host -vga virtio &
    just _run-vm {{host}} &
    just _run-novnc
  
run-isoConfigurations host:
    nix build .#install-isoConfigurations.{{host}}
    just _run-vm {{host}}
    just _run-novnc

_run-vm host:
    # Port forwarding. Port 2222 on host -> 22 in VM. Access via ssh -p 2222 my@machine
    ./result/bin/run-{{host}}-vm -vnc :1 \
      -netdev user,id=net0,hostfwd=tcp::2222-:22 \
      -device virtio-net-pci,netdev=net0

_run-novnc:
    nix run nixpkgs#novnc -- --vnc localhost:5901 


# 
#
# _
# 
# 

