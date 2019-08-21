{ nixpkgs ? (import ./.nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./.nix/revealjs.nix {};

  mkRevealJs = pkgs.writeShellScriptBin "mkrevealjs" ''
    ${pkgs.pandoc}/bin/pandoc -t revealjs -V revealjs-url=${revealjs}/reveal.js $*
  '';

  mkSlides = pkgs.writeShellScriptBin "mkslides" ''
    ${mkRevealJs}/bin/mkrevealjs --highlight-style=tango -s -o index.html slides.md
  '';
in
  pkgs.stdenv.mkDerivation {
    name = "presentations-shell";
    buildInputs = [ pkgs.pandoc revealjs mkRevealJs mkSlides ];
    shellHook = ''
      export LANG=en_US.UTF-8
      eval "$( ${pkgs.pandoc}/bin/pandoc --bash-completion )"
      echo "Welcome!"
    '';
  }
