# lib/my-lib/default.nix
{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
in {
  # Parameterized version - takes a directory path
  autoImportNamedFiles = dir:
    filter (hasSuffix ".nix") (
      map toString (filter (p: p != (dir + "/default.nix")) (listFilesRecursive dir))
    );
}
