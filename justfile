#
# Global vars
# 

default := "default"


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
    
