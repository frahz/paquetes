{
  description = "A very basic flake for packages";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );

    in
    {
      packages = forAllSystems (
        pkgs:
        lib.filterAttrs (
          _: package: lib.isDerivation package && lib.meta.availableOn pkgs.stdenv.hostPlatform package
        ) (import ./default.nix { inherit pkgs; })
      );
      hydraJobs = self.packages;
      overlays.default = _: prev: import ./default.nix { pkgs = prev; };
      nixosModules = import ./modules/nixos;

      # thanks to isabelroses
      # https://github.com/tgirlcloud/pkgs/blob/91c9e8ac0711a036b9de1a1621fad42e1db4d5a7/flake.nix#L84
      apps = forAllSystems (pkgs: {
        update = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update";

              runtimeInputs = [
                pkgs.nix-update
              ];

              text = lib.concatStringsSep "\n" (
                lib.mapAttrsToList (
                  name: pkg:
                  if pkg ? updateScript && pkg.updateScript != null then
                    lib.escapeShellArgs [
                      "nix-update"
                      "--flake"
                      "--use-update-script"
                      "--commit"
                      name
                    ]
                  else
                    "# no update script for ${name}"
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
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };

  nixConfig = {
    extra-substituters = [ "https://frahz-pkgs.cachix.org" ];
    extra-trusted-public-keys = [
      "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
    ];
  };
}
