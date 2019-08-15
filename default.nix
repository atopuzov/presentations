{ nixpkgs ? (import ./nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;
  revealjs = pkgs.callPackage ./nix/revealjs.nix {};
  presentations = map(dir: {
    name = dir;
    path = pkgs.callPackage (./. + "/${dir}") { inherit revealjs; };
  });
  dirs = [ "calculate-checksum" ];
  indexHtml = pkgs.writeTextFile {
    name = "index.html";
    text = ''
      <!doctype html>
      <html lang=en>
        <head>
        <meta charset=utf-8>
        <title>Presentations</title>
        </head>
        <body>
          ${lib.concatMapStringsSep "\n" (dir: "<li><a href='${dir}'>${dir}</a></li>") dirs}
        </body>
     </html>
    '';
  };
  cname = pkgs.writeTextFile {
    name = "cname";
    text = "talks.topuzovic.net";
  };
  nojekill = pkgs.writeTextFile {
    name = "nojekyll";
    text = "";
  };
in
  pkgs.linkFarm "presentations" ([
  {
    name = ".nojekyll";
    path = nojekill;
  }
  {
    name = "CNAME";
    path = cname;
  }
  {
    name = "index.html";
    path = indexHtml;
  }] ++ presentations dirs)
