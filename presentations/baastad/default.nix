{ stdenv, pandoc, revealjs
}:
stdenv.mkDerivation rec {
  name = "mss-presentation";
  src = ./.;

  buildPhase = ''
    pandoc \
      -t revealjs \
      -V revealjs-url=./reveal.js \
      --slide-level=2 \
      --no-highlight \
      --template=custom.revealjs \
      --standalone \
      --output index.html \
      slides.md
  '';

  installPhase = ''
    mkdir -p $out
    cp index.html $out
    cp -r css/ $out
    cp -r ${revealjs}/reveal.js/ $out
  '';

  buildInputs = [ pandoc revealjs ];
}
