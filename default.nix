{ nixpkgs ? (import ./nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./nix/revealjs.nix {};
in pkgs.buildEnv {
  name = "presentations";

  paths = let
    calculate-checksum = pkgs.callPackage
      ./calculate-checksum/default.nix { inherit revealjs;  };
  in
    [ calculate-checksum ];
}
