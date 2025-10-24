{
  description = "A very basic flake for packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

    in
    {
      packages = forAllSystems (pkgs: import ./default.nix { inherit pkgs; });

      nixosModules = import ./modules/nixos self;

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      hydraJobs = self.packages;

      # thanks to isabelroses
      # https://github.com/tgirlcloud/pkgs/blob/91c9e8ac0711a036b9de1a1621fad42e1db4d5a7/flake.nix#L84
      apps = forAllSystems (pkgs: {
        update = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update";

              text = lib.concatStringsSep "\n" (
                lib.mapAttrsToList (
                  name: pkg:
                  if pkg ? updateScript && (lib.isList pkg.updateScript) then
                    lib.escapeShellArgs (
                      if (lib.match "nix-update|.*/nix-update" (lib.head pkg.updateScript) != null) then
                        pkg.updateScript
                        ++ [
                          "--commit"
                          name
                        ]
                      else
                        pkg.updateScript
                    )
                  else
                    toString pkg.updateScript or "# no update script for ${name}"
                ) self.packages.${pkgs.stdenv.hostPlatform.system}
              );
            }
          );
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.nix-update
          ];
        };
      });
    };

  nixConfig = {
    extra-substituters = [ "https://frahz-pkgs.cachix.org" ];
    extra-trusted-public-keys = [
      "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
    ];
  };
}
