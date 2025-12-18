# lib/external/default.nix
# Credit to jakehamilton
{
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (inputs) deploy-rs;
in
  with lib; rec {
    mkOpt = type: default: description:
      mkOption {inherit type default description;};

    mkOpt' = type: default: mkOpt type default null;

    mkBoolOpt = mkOpt types.bool;

    mkBoolOpt' = mkOpt' types.bool;

    enabled = {enable = true;};

    disabled = {enable = false;};

    # deploy-rs
    mkDeploy = {
      self,
      overrides ? {},
    }: let
      hosts = self.nixosConfigurations or {};
      names = builtins.attrNames hosts;
      nodes =
        lib.foldl
        (result: name: let
          host = hosts.${name};
          user = host.config.myVars.username or null;
          inherit (host.pkgs) system;
        in
          result
          // {
            ${name} =
              (overrides.${name} or {})
              // {
                hostname = overrides.${name}.hostname or "${name}";
                profiles =
                  (overrides.${name}.profiles or {})
                  // {
                    system =
                      (overrides.${name}.profiles.system or {})
                      // {
                        path = deploy-rs.lib.${system}.activate.nixos host;
                      }
                      # Not useful for me
                      // lib.optionalAttrs (user != null) {
                        user = "root";
                        sshUser = "root";
                      }
                      // lib.optionalAttrs
                      (host.config.${namespace}.security.doas.enable or false) # TODO: adapt to danielgomezcoder
                      
                      {
                        sudo = "doas -u";
                      };
                  };
              };
          })
        {}
        names;
    in {inherit nodes;};
  }
