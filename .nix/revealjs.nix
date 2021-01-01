{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.1.0";
  pname = "reveal.js";

  src = fetchurl {
    url = "https://github.com/hakimel/reveal.js/archive/4.1.0.tar.gz";
    sha256 = "0bv3z6kp4f77w75wrzs9av1ip8q8x8z7a6y8ad961c1y4d6vki99";
  };

  installPhase = ''
    mkdir -p $out/reveal.js/
    cp -r {css,js,dist,plugin} $out/reveal.js/
  '';
}
