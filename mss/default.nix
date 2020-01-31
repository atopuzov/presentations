{ stdenv, pandoc, revealjs
}:
stdenv.mkDerivation rec {
  name = "mss-presentation";
  src = ./.;

  buildPhase = ''
    pandoc -t revealjs \
      --slide-level=2 \
      --no-highlight \
      --template=custom.revealjs \
      -s \
      -o index.html slides.md
  '';

  installPhase = ''
    mkdir -p $out
    cp index.html $out
    cp -r css/ $out
    cp -r ${revealjs}/reveal.js/ $out
  '';

  buildInputs = [ pandoc revealjs ];
}
