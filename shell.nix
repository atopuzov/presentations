{ nixpkgs ? (import ./.nix/nixpkgs.nix)
}:
let
  pkgs = import nixpkgs {};
  revealjs = pkgs.callPackage ./.nix/revealjs.nix {};

  # reveal.js 3.7.0 has minified version, needed for self-contained
  revealjs_37 = revealjs.overrideAttrs (oldAttrs: rec {
    version = "3.7.0";
    name = "reveal.js-${version}";
    src = pkgs.fetchurl {
      url = "https://github.com/hakimel/reveal.js/archive/${version}.tar.gz";
      sha256 = "177viqy19ymlp46dhw4p1i6wxjhxw67ky918f84zbvwxdkjs3j5d";
    };
  });

  mkRevealJs = pkgs.writeShellScriptBin "mkrevealjs" ''
    ${pkgs.pandoc}/bin/pandoc \
      -t revealjs \
      -V revealjs-url=${revealjs}/reveal.js \
      $*
  '';

  linkRevealJs = pkgs.writeShellScriptBin "linkrevealjs" ''
    ${pkgs.coreutils}/bin/ln -sf ${revealjs}/reveal.js .
  '';

  # Standalone/selfcontained version (3.8.0 does not include minified version)
  # -V revealjs-url=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.7.0 \
  mkSlides2 = pkgs.writeShellScriptBin "mkslides2" ''
    ${pkgs.pandoc}/bin/pandoc \
      -t revealjs \
      -V revealjs-url=${revealjs_37}/reveal.js \
      --self-contained \
      --standalone \
      --highlight-style=tango \
      --output index.html \
      slides.md
  '';

  mkSlides = pkgs.writeShellScriptBin "mkslides" ''
    ${mkRevealJs}/bin/mkrevealjs \
      --standalone \
      --highlight-style=tango \
      --output index.html \
       slides.md
  '';

  mkSlidesNH = pkgs.writeShellScriptBin "mkslidesnh" ''
    ${mkRevealJs}/bin/mkrevealjs \
      --standalone \
      --no-highlight \
      --slide-level=2 \
      --template=custom.revealjs \
      --output index.html \
       slides.md
  '';

in
  pkgs.stdenv.mkDerivation {
    name = "presentations-shell";
    buildInputs = [ pkgs.pandoc revealjs mkRevealJs mkSlides mkSlidesNH linkRevealJs mkSlides2 ];
    shellHook = ''
      export LANG=en_US.UTF-8
      eval "$( ${pkgs.pandoc}/bin/pandoc --bash-completion )"
      echo "Welcome!"
    '';
  }
