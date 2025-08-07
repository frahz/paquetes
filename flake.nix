{
  description = "A very basic flake for packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) callPackageWith;
      inherit (lib.filesystem) packagesFromDirectoryRecursive;

      systems = [
        "x86_64-linux"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

    in
    {
      packages = forAllSystems (
        pkgs:
        packagesFromDirectoryRecursive {
          callPackage = callPackageWith (pkgs);
          directory = ./pkgs;
        } // {
          default = pkgs.emptyFile;
        }
      );

      nixosModules = import ./modules/nixos self;

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      hydraJobs = self.packages;
    };

  nixConfig = {
    extra-substituters = [ "https://frahz.cachix.org" ];
    extra-trusted-public-keys = [
      "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
    ];
  };
}
