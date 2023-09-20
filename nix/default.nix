{ src
, pkgs
, static
, inputMap
, ...
}:

let
  musl64 = pkgs.pkgsCross.musl64;

  pkgSet = if static then musl64 else pkgs;

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

      } // pkgs.lib.mkIf static {
        ogmios.components.exes.ogmios.configureFlags = pkgs.lib.optionals
          musl64.stdenv.hostPlatform.isMusl [
          "--disable-executable-dynamic"
          "--disable-shared"
          "--ghc-option=-optl=-pthread"
          "--ghc-option=-optl=-static"
          "--ghc-option=-optl=-L${musl64.gmp6.override { withStatic = true; }}/lib"
          "--ghc-option=-optl=-L${musl64.zlib.override { static = true; }}/lib"
        ];
      };
    }];

  };
in
pkgSet.haskell-nix.cabalProject project
