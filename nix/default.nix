{ src
, pkgs
, inputMap
, ...
}:

let
  project = {
    inherit src inputMap;

    name = "ogmios";

    compiler-nix-name = "ghc963";

    shell = {
      inputsFrom = [ pkgs.libsodium-vrf ];

      withHoogle = true;

      tools = {
        cabal = "latest";
        haskell-language-server = "latest";
      };

      exactDeps = true;

      nativeBuildInputs = [ pkgs.libsodium-vrf pkgs.secp256k1 ];
    };

    modules = [{
      packages = {
        cardano-crypto-praos.components.library.pkgconfig =
          pkgs.lib.mkForce [ [ pkgs.libsodium-vrf ] ];

        cardano-crypto-class.components.library.pkgconfig =
          pkgs.lib.mkForce [ [ pkgs.libsodium-vrf pkgs.secp256k1 pkgs.libblst ] ];


      };
    }];

  };
in
pkgs.haskell-nix.cabalProject project
