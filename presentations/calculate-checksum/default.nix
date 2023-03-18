{ stdenv, pandoc, revealjs
}:
stdenv.mkDerivation rec {
  name = "calculate-checksum-presentation";
  src = ./.;

  buildPhase = ''
    pandoc \
      -t revealjs \
      -V revealjs-url=./reveal.js \
      --highlight-style=tango \
      --standalone \
      --output index.html \
      slides.md
  '';

  installPhase = ''
    mkdir -p $out
    cp index.html $out
    cp -r images/ $out
    cp -r ${revealjs}/reveal.js/ $out
  '';

  buildInputs = [ pandoc revealjs ];
}
