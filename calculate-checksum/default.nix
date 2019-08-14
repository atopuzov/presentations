{ stdenv, pandoc, revealjs
}:
stdenv.mkDerivation rec {
  name = "calculate-checksum-presentation";
  src = ./.;

  buildPhase = ''
    pandoc -t revealjs --highlight-style=zenburn -s -o ${name}.html slides.md
  '';

  installPhase = ''
    mkdir -p $out
    cp ${name}.html $out
    cp -r images/ $out
    cp -r ${revealjs}/reveal.js/ $out
  '';

  buildInputs = [ pandoc revealjs ];
}
