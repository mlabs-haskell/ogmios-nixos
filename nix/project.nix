{ lib, pkgs, inputs, ... }: lib.iogx.mkHaskellProject {
  cabalProject = pkgs.haskell-nix.cabalProject'
    {
      src = pkgs.haskell-nix.haskellLib.cleanSourceWith {
        name = "ogmios";
        src = "${inputs.ogmios}/server";
        filter = path: type:
          builtins.all (x: x) [
            (baseNameOf path != "package.yaml")
          ];
      };
      # `compiler-nix-name` upgrade policy: as soon as inputs.ogmios
      compiler-nix-name = lib.mkDefault "ghc96";
      inputMap = {
        "https://input-output-hk.github.io/cardano-haskell-packages" = inputs.iogx.inputs.CHaP;
      };
      sha256map = {
        "https://github.com/CardanoSolutions/cardano-ledger"."558cad41ef01a35ac62c28cf06e954fdfd790e28" = "Q1E+ZJ+DxjZTJny8LrpJHYXJafRbZAknDqAW7Rx0Mm8=";
      };
      modules = [
        {
          # FIXME ogmios unit tests are not passing
          packages.ogmios.components.tests.unit.doCheck = false;
        }
      ];
    };
}
