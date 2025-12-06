#
# Global vars
# 

default := "default"
currentHost := "`hostname`"


# 
# Building, evaluation, diagnostic
# 

build-configuration host:
    nix build .#nixosConfigurations.test.config.system.build.toplevel

eval-configuration host:
    nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel.drvPath


#
# Development
# 

development-shell shell=(default):
    nix develop .#{{shell}}
    
#
# Deployment
# 

deploy-rs target=(currentHost):
      nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#{{target}}"

deploy-rs-all: 
    #!/usr/bin/env bash
    # TODO: add usb device(s)
    # TODO: make into one-off systemd unit?
    : > /var/tmp/just-apply_all.log
    just _update_secrets
    git add --all
    for i in server desktop laptop living-room test-machine nas-server llm-machine hetzner-vps 3D-printer; do
        nohup nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#$i" \
        | tee -a /var/tmp/just-apply_all.log \
        | tee "/var/tmp/just-apply_$i.log" >/dev/null &
    done 
    

