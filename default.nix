{ nixpkgs ? (import ./nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./nix/revealjs.nix {};
  presentations = map(dir: {
    name = dir;
    path = pkgs.callPackage (./. + "/${dir}") { inherit revealjs; };
  });
in
  pkgs.linkFarm "presentations" ([
  {
    name = "index.html";
    path = ./index.html;
  }] ++ presentations [ "calculate-checksum" ])

