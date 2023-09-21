{ src
, pkgs
, inputMap
, ...
}:

let
  project = {
    inherit src inputMap;

    name = "ogmios";

    compiler-nix-name = "ghc8107";

    shell = {
      inputsFrom = [ pkgs.libsodium-vrf ];

      # Make sure to keep this list updated after upgrading git dependencies!
      additional = ps: with ps; [
        cardano-binary
        cardano-crypto
        cardano-crypto-class
        cardano-crypto-praos
        cardano-crypto-tests
        cardano-slotting
        cardano-prelude
        contra-tracer
        flat
        hjsonpointer
        hjsonschema
        iohk-monitoring
        io-classes
        io-sim
        ouroboros-consensus
        ouroboros-consensus-cardano
        ouroboros-network
        ouroboros-network-framework
        typed-protocols
        typed-protocols-cborg
        wai-routes
      ];

      withHoogle = true;

      tools = {
        cabal = "latest";
        haskell-language-server = "1.5.0.0";
      };

      exactDeps = true;

      nativeBuildInputs = [ pkgs.libsodium-vrf pkgs.secp256k1 ];
    };

    modules = [{
      packages = {
        cardano-crypto-praos.components.library.pkgconfig =
          pkgs.lib.mkForce [ [ pkgs.libsodium-vrf ] ];

        cardano-crypto-class.components.library.pkgconfig =
          pkgs.lib.mkForce [ [ pkgs.libsodium-vrf pkgs.secp256k1 ] ];

      };
    }];

  };
in
pkgs.haskell-nix.cabalProject project
