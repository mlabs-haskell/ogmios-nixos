{
  description = "Nix flake for ogmios";
  inputs = {
    iogx.url = "github:input-output-hk/iogx";
    cardano-world.url = "github:IntersectMBO/cardano-world";
    cardano-node.follows = "cardano-world/cardano-node";
    ogmios = {
      url = "github:CardanoSolutions/ogmios";
      flake = false;
    };
  };
  outputs = inputs@{ self, ... }:
    let
      # TODO enable ogmios supported OS's
      systems = [ "x86_64-linux" ];
    in
    inputs.iogx.lib.mkFlake {
      inherit inputs systems;
      repoRoot = ./.;
      outputs = import ./nix/outputs.nix;
    };
  nixConfig = {
    extra-substituters = [
      "https://cache.iog.io"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    allow-import-from-derivation = true;
  };
}

