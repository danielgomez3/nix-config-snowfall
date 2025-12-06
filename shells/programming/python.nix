# shells/python.nix
{
  inputs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  devShells.x86_64-linux.python = let
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
  in
    pkgs.mkShell {
      packages = with pkgs; [
        python3
        python3Packages.pip
        python3Packages.virtualenv
        nodejs
      ];
      shellHook = ''
        echo "Python development shell"
      '';
    };
}
