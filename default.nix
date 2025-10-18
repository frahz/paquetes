{
  pkgs ? import <nixpkgs> {
    inherit system;
    overlays = [ ];
    config.allowUnfree = true;
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:
let
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
in
packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./pkgs;
}
