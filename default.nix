{ nixpkgs ? (import ./nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./nix/revealjs.nix {};
in pkgs.linkFarm "presentations" [
  {
    name = "calculate-checksum";
    path = pkgs.callPackage ./calculate-checksum/default.nix { inherit revealjs;  };
  }]

