{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.7.0";
  pname = "reveal.js";

  src = fetchurl {
    url = "https://github.com/hakimel/reveal.js/archive/${version}.tar.gz";
    sha256 = "177viqy19ymlp46dhw4p1i6wxjhxw67ky918f84zbvwxdkjs3j5d";
  };

  installPhase = ''
    mkdir -p $out/reveal.js/
    cp -r {css,js,lib,plugin} $out/reveal.js/
  '';
}
