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
      #sha256map = {};
      modules = [{
        packages.cryptonite.flags.support_rdrand = false;
        packages.bitvec.flags.simd = false;
        packages.quickcheck-state-machine.flags.no-vendored-treediff = true;
        packages.text.flags.simdutf = false;
        packages.formatting.flags.no-double-conversion = true;
        # FIXME ogmios unit tests are not passing
        packages.ogmios.components.tests.unit.doCheck = false;
      }];
    };
}
