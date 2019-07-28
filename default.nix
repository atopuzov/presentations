{ nixpkgs ? import <nixpkgs> {}
}:
let
  revealjs = nixpkgs.callPackage ./nix/revealjs.nix {};
in nixpkgs.buildEnv {
  name = "presentations";

  paths = let
    calculate-checksum = nixpkgs.callPackage
      ./calculate-checksum/default.nix { inherit revealjs;  };
  in
    [ calculate-checksum ];
}
