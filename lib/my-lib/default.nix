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

  # Takes a full file path, extracts just the name without suffix
  _fileNameNoSuffix = fullFilePath:
    baseNameOf fullFilePath
    |> toString
    |> lib.strings.removeSuffix ".nix";

  # Automatically discover .nix files
  _discoverFiles = dir:
    dir
    |> listFilesRecursive
    |> filter (hasSuffix ".nix")
    |> filter (x: !(hasSuffix "default.nix" (toString x)));

  _wrapFileAsModule = platform: category: fullFilePath: {
    config,
    lib,
    ...
  }: let
    module = lib._fileNameNoSuffix fullFilePath;
  in {
    options.profiles.${namespace}.my.${platform}.${category}.${module} = {
      enable = lib.mkEnableOption "Enable custom '${platform}' module, category '${category}', module '${module}', for namespace '${namespace}'.";
    };
    config = lib.mkIf config.profiles.${namespace}.my.${platform}.${category}.${module}.enable {
      imports = fullFilePath;
    };
  };

  # Automagically wraps all .nix file(s) discovered into a simple custom module.
  WrapFilesAsModules = platform: category: searchDir: {
    config,
    lib,
    ...
  }: let
  in {
    imports = lib._discoverFiles searchDir |> builtins.map lib._wrapFileAsModule platform category;
  };
}
