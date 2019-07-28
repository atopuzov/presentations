{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.8.0";
  name = "reveal.js-${version}";

  src = fetchurl {
    url = "https://github.com/hakimel/reveal.js/archive/${version}.tar.gz";
    sha256 = "0m8i5xf0yv4i31dh1ikb4y9b1hlbmfjz7ifihgql9vjjjxjkiyng";
  };

  installPhase = ''
    mkdir -p $out/reveal.js/
    cp -r {css,js,lib,plugin} $out/reveal.js/
  '';
}
