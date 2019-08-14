{ nixpkgs ? (import ./nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./nix/revealjs.nix {};
in pkgs.linkFarm "presentations" [
  {
    name = "index.html";
    path = ./index.html;
  }
  {
    name = "calculate-checksum";
    path = pkgs.callPackage ./calculate-checksum/default.nix { inherit revealjs;  };
  }]

